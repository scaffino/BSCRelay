pragma solidity >=0.7.0 <0.9.0;
pragma experimental ABIEncoderV2; //returning struct is not fully supported. I need this line to enable it

import "hardhat/console.sol";
import "./RLPReader.sol";
import "./ECDSA.sol";
import "./BytesLib.sol";

contract BSCRelay {

    //using RLPReader for *;
    using RLPReader for RLPReader.RLPItem;
    using RLPReader for RLPReader.Iterator;
    using RLPReader for bytes;

    struct ConsensusState {
        bytes32 validatorSetHash;
        address relayerAddress; //address that receives the fee
    }

    //uint64 is the blockHeight
    mapping(uint64 => ConsensusState) public consensusStates;
    uint64 currentHeight = 0;
    uint validatorNumber = 21;
    uint constant signatureBytes = 65;

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

    constructor (address[] memory validatorSet) {
        // only the hash of the validator set is stored. The validator set has to be provided
        bytes32 hashVS = keccak256(abi.encode(validatorSet));
        consensusStates[0] = ConsensusState(hashVS, address(0));
    }

    function compareBlockHeader (bytes memory rlpSignedHeader, bytes memory rlpUnsignedHeader) external view returns(bool) {
        RLPReader.RLPItem[] memory unsignedHeader = rlpUnsignedHeader.toRlpItem().toList();
        RLPReader.RLPItem[] memory signedHeader = rlpSignedHeader.toRlpItem().toList();

        if(unsignedHeader.length == signedHeader.length - 1) return false;

        // Check header and signedHeader contain the same data
        for (uint256 i=0; i < rlpSignedHeader.length; i++) {
            // Skip extra data field
            if (i==12) {

                bytes memory extraDataSignedHeader = signedHeader[i].toBytes(); //unsigned header does contain chainId, extradata 12th
                bytes memory extraDataUnSignedHeader = unsignedHeader[i+1].toBytes(); //unsigned header does contain chainId, extradata 12th
                uint signatureStart = extraDataUnSignedHeader.length - signatureBytes;
                bytes memory extraDataUnsigned = BytesLib.slice(extraDataUnSignedHeader, 0, signatureStart);

                return keccak256(extraDataSignedHeader) == keccak256(extraDataUnSignedHeader); //true

            } else {
                return keccak256(unsignedHeader[i+1].toBytes()) == keccak256(signedHeader[i].toBytes()); //false
            }
        }
        return false;
    }

    // rlpHeader without validator signature, validatorSet is the validator set of the previous epoch block
    function submitEpochBlock(bytes[] memory rlpHeader, bytes[] memory signature, address[] memory validatorSet) external {

        //temporarily set to 2 for simplicity
        require(rlpHeader.length == 2, "rlpHeaders provided must be 12");
        require(signature.length == 2, "signatures provided must be 12");
        //we must set to 12
        //require(rlpHeader.length == 12, "rlpHeaders provided must be 12");
        //require(signature.length == 12, "signatures provided must be 12");

        require(consensusStates[currentHeight].validatorSetHash == keccak256(abi.encode(validatorSet)), "Wrong validator set provided.");

        // epoch blocks
        FullHeader memory currentBlockHeader = parseRlpEncodedHeader(rlpHeader[0]);
        FullHeader memory previousBlockHeader = currentBlockHeader;

        //for (uint jj = 0; jj < 12; jj++) {
        for (uint jj = 0; jj < 2; jj++) {

                if(jj == 0){
                    require(currentBlockHeader.blockNumber == currentHeight+200, "You must submit the next epoch block.");
                }

                //all blocks
                require(currentBlockHeader.mixHash == 0, "mixHash must be 0x0000000000000000000000000000000000000000000000000000000000000000");
                require(currentBlockHeader.difficulty == 2 || currentBlockHeader.difficulty == 1, "Difficulty is not correct, it must be 1 or 2.");

                //signature check
                address signer = verifyValidatorSignature(rlpHeader[jj], signature[jj]);
                console.log(signer);
                bool boolean = false;
                for (uint ii = 0; ii < validatorNumber; ii++) {
                    if (signer == validatorSet[ii]) {
                        boolean = true;
                        break;
                    }
                }
                require(boolean == true, "The validator of the block is not included in the validator set.");

                //chain check
                //check parent, check the blocks are not signed by the same validator set
                if (jj != 0) {
                    //I need to pass the signed rlp headers
                   // require(currentBlockHeader.parentHash == previousBlockHeader., "");
                }

                previousBlockHeader = currentBlockHeader;
                currentBlockHeader = parseRlpEncodedHeader(rlpHeader[jj]);

        }

        //if everything is okay, update the validator set
        FullHeader memory epochBlockHeader = parseRlpEncodedHeader(rlpHeader[0]);
        bytes[] memory newValidatorSet = getValidatorSet(epochBlockHeader.extraData);
        bytes32 hashVS = keccak256(abi.encode(newValidatorSet));
        currentHeight = currentHeight + 200;
        consensusStates[currentHeight] = ConsensusState(hashVS, msg.sender);
        console.log(currentHeight);

    }

    //rlpHeader without validator signature
    function decodeRLPHeader(bytes memory rlpHeader) external view returns(FullHeader memory){
        FullHeader memory fullHeader = parseRlpEncodedHeader(rlpHeader);
        /*console.logBytes32(fullHeader.parentHash);
        console.logBytes32(fullHeader.uncleHash);
        console.logAddress(fullHeader.miner);
        console.logBytes32(fullHeader.stateRoot);
        console.logBytes32(fullHeader.transactionsRoot);
        console.logBytes32(fullHeader.receiptsRoot);
        console.log(fullHeader.difficulty);
        console.log(fullHeader.blockNumber);
        console.log(fullHeader.gasLimit);
        console.log(fullHeader.gasUsed);
        console.log(fullHeader.timestamp);
        console.logBytes(fullHeader.extraData);
        console.log(fullHeader.nonce);*/

        return fullHeader;
    }

    //extra_data without validator signature
    function getValidatorSet(bytes memory extraData) public view returns(bytes[] memory){
        uint extraVanity = 32;
        uint addressLength = 20;
        bytes[] memory validatorSet = new bytes[](validatorNumber);
        for (uint ii = 0; ii < validatorNumber; ii++){
            validatorSet[ii] = BytesLib.slice(extraData, extraVanity, addressLength);
            extraVanity += addressLength;
        }

        return validatorSet;
    }

    function getValidatorSignature(bytes calldata extraData) external view returns (bytes memory) {
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
                if( idx == 0 ) header.chainId = it.next().toUint();
                else if( idx ==  1) header.parentHash = bytes32(it.next().toUint());
                else if ( idx == 2 ) header.uncleHash = bytes32(it.next().toUint());
                else if ( idx == 3 ) header.miner = address(it.next().toUint());
                else if ( idx == 4 ) header.stateRoot = bytes32(it.next().toUint());
                else if ( idx == 5 ) header.transactionsRoot = bytes32(it.next().toUint());
                else if ( idx == 6 ) header.receiptsRoot = bytes32(it.next().toUint());
                else if ( idx == 7 ) header.bloom = it.next().toBytes();
                else if ( idx == 8 ) header.difficulty = it.next().toUint();
                else if ( idx == 9 ) header.blockNumber = it.next().toUint();
                else if ( idx == 10 ) header.gasLimit = it.next().toUint();
                else if ( idx == 11 ) header.gasUsed = it.next().toUint();
                else if ( idx == 12 ) header.timestamp = it.next().toUint();
                else if ( idx == 13 ) header.extraData = it.next().toBytes();
                else if ( idx == 14 ) header.mixHash = bytes32(it.next().toUint());
                else if ( idx == 15 ) header.nonce = it.next().toUint();
                else it.next();

                idx++;
            }

        return header;
    }

}


