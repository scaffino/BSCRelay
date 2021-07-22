pragma solidity >=0.7.0 <0.9.0;
pragma experimental ABIEncoderV2; //returning struct is not fully supported. I need this line to enable it

// TODO
// - add compensation to the relayer for the block verification
// - add validation for block with two validator sets
// - add getter methods for last submitted epoch block (read current state of the relay)

import "hardhat/console.sol";
import "./RLPReader.sol";
import "./ECDSA.sol";
import "./BytesLib.sol";

/// @title BSCRelay: An Ethereum smart contract enabling cross-blockchain block verification
/// @author Giulia Scaffino, Michael Sober
/// @notice You can use this contract for submitting epoch block headers and
///         for verifying whether a block is included in the BSC blockchain

contract BSCRelay {

    using RLPReader for RLPReader.RLPItem;
    using RLPReader for RLPReader.Iterator;
    using RLPReader for bytes;

    struct ConsensusState {
        bytes32 validatorSetHash;
        address relayerAddress; //address that receives the fee
    }

    mapping(uint64 => ConsensusState) public consensusStates;   //uint64 is the blockHeight
    uint64 currentHeight = 0;
    uint validatorNumber = 21;
    uint constant signatureBytes = 65;
    uint constant thresholdNumberBlocks = 12;

    //events
    event EpochBlockSubmitted(uint256 indexed blockNumber); //I can filter for indexed variables. Max 3 indexed variables per event

    // FullHeader without validator signature
    struct FullHeader {
        uint chainId;
        bytes32 parentHash;
        bytes32 uncleHash;
        address miner;
        bytes32 stateRoot;
        bytes32 transactionsRoot;
        bytes32 receiptsRoot;
        bytes bloom;
        uint difficulty;
        uint blockNumber;
        uint gasLimit;
        uint gasUsed;
        uint timestamp;
        bytes extraData;
        bytes32 mixHash;
        uint nonce;
    }

    constructor (address[] memory validatorSet, uint64 blockHeight) {
        // only the hash of the validator set is stored. The validator set has to be provided
        bytes32 hashVS = keccak256(abi.encode(validatorSet));
        consensusStates[blockHeight] = ConsensusState(hashVS, address(0));
        currentHeight = blockHeight;
    }

    //unsigned needs chainId
    //signed doesn't need chainId
    function compareBlockHeader (bytes memory rlpUnsignedHeader, bytes memory rlpSignedHeader) public view returns(bool) {
        RLPReader.RLPItem[] memory unsignedHeader = rlpUnsignedHeader.toRlpItem().toList();
        RLPReader.RLPItem[] memory signedHeader = rlpSignedHeader.toRlpItem().toList();

        if(unsignedHeader.length != signedHeader.length + 1) return false;

        // Check unsignedHeader and signedHeader contain the same data
        for (uint256 kk = 0; kk < signedHeader.length; kk++) {
            // Skip extra data field
            if (kk == thresholdNumberBlocks) {

                bytes memory extraDataSignedHeader = signedHeader[kk].toBytes();
                bytes memory extraDataUnSignedHeader = unsignedHeader[kk+1].toBytes();
                uint signatureStart = extraDataSignedHeader.length - signatureBytes;
                bytes memory extraDataUnsigned = BytesLib.slice(extraDataSignedHeader, 0, signatureStart);

                if (keccak256(extraDataUnsigned) != keccak256(extraDataUnSignedHeader)) return false;

            } else {
                if (unsignedHeader[kk+1].rlpBytesKeccak256() != signedHeader[kk].rlpBytesKeccak256()) return false;
            }
        }
        return true;
    }

    function submitEpochBlock(bytes[] memory rlpUnsignedHeaders, bytes[] memory rlpSignedHeaders, address[] memory validatorSet) external {

        require(rlpUnsignedHeaders.length == thresholdNumberBlocks, "rlpHeaders provided must be 12");
        require(rlpSignedHeaders.length == thresholdNumberBlocks, "rlpSignedHeader provided must be 12");
        require(consensusStates[currentHeight].validatorSetHash == keccak256(abi.encode(validatorSet)), "Wrong validator set provided. You must provide the current validator set.");

        address[] memory signers = new address[](thresholdNumberBlocks);

        for (uint jj = 0; jj < thresholdNumberBlocks; jj++) {
            //console.log("Loop start:", gasleft());

            RLPReader.RLPItem[] memory currentBlockHeaderUnsigned = rlpUnsignedHeaders[jj].toRlpItem().toList();
            RLPReader.RLPItem[] memory signedHeader = rlpSignedHeaders[jj].toRlpItem().toList();

            //console.log("Block number:", convert(currentBlockHeaderUnsigned[9].toUint()));

            require(compareBlockHeader(rlpUnsignedHeaders[jj], rlpSignedHeaders[jj]), "The signed and unsigned headers do not match");
            //console.log("Compare header:", gasleft());
            //update validator set
            if(jj == 0){
                require(currentBlockHeaderUnsigned[9].toUint() == currentHeight + 200, "You must submit the next epoch block.");

                address[] memory newValidatorSet = getValidatorSet(currentBlockHeaderUnsigned[13].toBytes());
                bytes32 hashVS = keccak256(abi.encode(newValidatorSet));
                currentHeight = currentHeight + 200;
                consensusStates[currentHeight] = ConsensusState(hashVS, msg.sender);

            }

            require(currentBlockHeaderUnsigned[14].toUint() == 0, "mixHash must be 0x0000000000000000000000000000000000000000000000000000000000000000");
            require(currentBlockHeaderUnsigned[8].toUint() == 2 || currentBlockHeaderUnsigned[8].toUint() == 1, "Difficulty is not correct, it must be 1 or 2.");

            //signature check
            bytes memory signature = getValidatorSignature(signedHeader[12].toBytes());
            address signer = verifyValidatorSignature(rlpUnsignedHeaders[jj], signature);
            bool isIncluded = false;
            for (uint ii = 0; ii < validatorNumber; ii++) {
                if (signer == validatorSet[ii]) {
                    isIncluded = true;
                    break;
                }
            }
            require(isIncluded, "The validator of the block is not included in the validator set.");

            //check the blocks have all different signers (we assume that at least 2/3+1 validators are honest and they all do their job)
            for (uint ii = 0; ii < jj; ii++) {
                require(signer != signers[ii], "Same signer recurring. Not valid blocks.");
            }
            signers[jj] = signer;
            //console.log("Check double:", gasleft());
            // check the 12 blocks are a chain
            if (jj != 0) {
                bytes32 blockHash = keccak256(rlpSignedHeaders[jj-1]);
                require(bytes32(currentBlockHeaderUnsigned[1].toUint()) == blockHash , "Wrong parent, this is not a chain.");
            }
        }

        RLPReader.RLPItem[] memory newEpochBlockNumber = rlpUnsignedHeaders[0].toRlpItem().toList();
        emit EpochBlockSubmitted(newEpochBlockNumber[9].toUint());
    }

    function verifyBlock(bytes[] memory rlpUnsignedHeaders, bytes[] memory rlpSignedHeaders, address[] memory validatorSet) external returns(bool){

        require(rlpUnsignedHeaders.length == thresholdNumberBlocks, "rlpHeaders provided must be 12");
        require(rlpSignedHeaders.length == thresholdNumberBlocks, "rlpSignedHeader provided must be 12");

        require(consensusStates[currentHeight].validatorSetHash == keccak256(abi.encode(validatorSet)), "Wrong validator set provided. You must provide the current validator set.");

        address[] memory signers = new address[](thresholdNumberBlocks);

        for (uint jj = 0; jj < thresholdNumberBlocks; jj++) {

            RLPReader.RLPItem[] memory currentBlockHeaderUnsigned = rlpUnsignedHeaders[jj].toRlpItem().toList();
            RLPReader.RLPItem[] memory signedHeader = rlpSignedHeaders[jj].toRlpItem().toList();

            require(compareBlockHeader(rlpUnsignedHeaders[jj], rlpSignedHeaders[jj]), "The signed and unsigned headers do not match");

            uint64 blockNumber = convert(currentBlockHeaderUnsigned[9].toUint());
            uint64 moduloBlockNumber = blockNumber % 200;
            require(moduloBlockNumber >= 12 || moduloBlockNumber < 1, "Block verification for block height comprised in the range [E_b + 1 , E_b + N/2 - 1] is not yet enabled.");
            //check if the validator set of block you want to verify is equal to the current validator set
            require(consensusStates[uint64((blockNumber/200)*200)].validatorSetHash == keccak256(abi.encode(validatorSet)), "You can only verify blocks whose validator set it is equal to the current one.");

            require(currentBlockHeaderUnsigned[14].toUint() == 0, "mixHash must be 0x0000000000000000000000000000000000000000000000000000000000000000");
            require(currentBlockHeaderUnsigned[8].toUint() == 2 || currentBlockHeaderUnsigned[8].toUint() == 1, "Difficulty is not correct, it must be 1 or 2.");

            //signature check
            bytes memory signature = getValidatorSignature(signedHeader[12].toBytes());
            address signer = verifyValidatorSignature(rlpUnsignedHeaders[jj], signature);
            bool isIncluded = false;
            for (uint ii = 0; ii < validatorNumber; ii++) {
                if (signer == validatorSet[ii]) {
                    isIncluded = true;
                    break;
                }
            }
            require(isIncluded, "The validator of the block is not included in the validator set.");

            //check the blocks have all different signers (we assume that at least 2/3+1 validators are honest and they all do their job)
            for (uint ii = 0; ii < jj; ii++) {
                require(signer != signers[ii], "Same signer recurring. Not valid blocks.");
            }

            signers[jj] = signer;
            // check the 12 blocks are a chain
            if (jj != 0) {
                bytes32 blockHash = keccak256(rlpSignedHeaders[jj-1]);
                require(bytes32(currentBlockHeaderUnsigned[1].toUint()) == blockHash , "Wrong parent, this is not a chain");
            }
        }
        return true;
    }



    //rlpHeader without validator signature
    function decodeRLPHeader(bytes memory rlpHeader) external view returns(FullHeader memory){
        FullHeader memory fullHeader = parseRlpEncodedHeader(rlpHeader);

        return fullHeader;
    }

    //extra_data without validator signature
    function getValidatorSet(bytes memory extraData) public view returns(address[] memory){
        uint extraVanity = 32;
        uint addressLength = 20;
        address[] memory validatorSet = new address[](validatorNumber);
        for (uint ii = 0; ii < validatorNumber; ii++){
            validatorSet[ii] = BytesLib.toAddress(BytesLib.slice(extraData, extraVanity, addressLength), 0);
            extraVanity += addressLength;
        }

        return validatorSet;
    }

    function getValidatorSignature(bytes memory extraData) public view returns (bytes memory) {
        uint signatureStart = extraData.length - signatureBytes;
        return BytesLib.slice(extraData, signatureStart, signatureBytes);
    }

    //rlpHeader without validator signature
    function verifyValidatorSignature(bytes memory rlpHeader, bytes memory signature) public view returns(address){
        bytes32 hashRLPHeader = keccak256(rlpHeader);
        return ECDSA.recover(hashRLPHeader, signature);
    }

    function parseRlpEncodedHeader(bytes memory rlpHeader) private view returns (FullHeader memory) {
        FullHeader memory header;

        RLPReader.Iterator memory it = rlpHeader.toRlpItem().iterator();
            uint idx;
            while(it.hasNext()) {
                if( idx == 0 ) header.chainId = it.next().toUint(); //there is not chainId in the signed header
                else if( idx ==  1) header.parentHash = bytes32(it.next().toUint()); //*
                else if ( idx == 2 ) header.uncleHash = bytes32(it.next().toUint());
                else if ( idx == 3 ) header.miner = address(it.next().toUint());
                else if ( idx == 4 ) header.stateRoot = bytes32(it.next().toUint());
                else if ( idx == 5 ) header.transactionsRoot = bytes32(it.next().toUint());
                else if ( idx == 6 ) header.receiptsRoot = bytes32(it.next().toUint());
                else if ( idx == 7 ) header.bloom = it.next().toBytes();
                else if ( idx == 8 ) header.difficulty = it.next().toUint();//*
                else if ( idx == 9 ) header.blockNumber = it.next().toUint();//*
                else if ( idx == 10 ) header.gasLimit = it.next().toUint();
                else if ( idx == 11 ) header.gasUsed = it.next().toUint();
                else if ( idx == 12 ) header.timestamp = it.next().toUint();
                else if ( idx == 13 ) header.extraData = it.next().toBytes();//*
                else if ( idx == 14 ) header.mixHash = bytes32(it.next().toUint());//*
                else if ( idx == 15 ) header.nonce = it.next().toUint();
                else it.next();

                idx++;
            }

        return header;
    }

    function convert(uint256 _a) private returns (uint64) {
        return uint64(_a);
    }

    // ================== GETTER FUNCTIONS ==================
    function getLastEpochBlockSubmitted() external view returns (uint64) {
        return currentHeight;
    }

    // ======================================================

}


