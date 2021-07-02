pragma solidity >=0.7.0 <0.9.0;
pragma experimental ABIEncoderV2; //returning struct is not fully supported. I need this line to enable it

import "hardhat/console.sol";
import "./RLPReader.sol";
import "./ECDSA.sol";
import "./BytesLib.sol";

contract BSCRelay {

    using RLPReader for *;

    struct ConsensusState {
        bytes32 validatorSetHash;
        address relayerAddress; //address that receives the fee
    }

    //uint64 is the blockHeight
    mapping(uint64 => ConsensusState) public consensusStates;
    uint64 currentHeight = 0;
    uint validatorNumber = 21;

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

    // rlpHeader without validator signature, validatorSet is the validator set of the previous epoch block
    function verifyHeader(bytes memory rlpHeader, bytes memory signature, address[] memory validatorSet) external {
        FullHeader memory fullHeader = parseRlpEncodedHeader(rlpHeader);
        require(fullHeader.mixHash == 0, "mixHash must be 0x0000000000000000000000000000000000000000000000000000000000000000");
        require(fullHeader.difficulty == 2 || fullHeader.difficulty == 1, "Difficulty is incorrect.");
        require(fullHeader.blockNumber != 0, "You can't submit the genesis block.");

        //if it is epoch block
        if (fullHeader.blockNumber % 200 == 0) {
            //check that all the epoch blocks are relayed. Skip an epoch block is not allowed
            require(fullHeader.blockNumber < currentHeight+201, "Previous epoch block is missing. You cannot submit subsequent epoch blocks if a previous one is missing.");

            //check if signature of the block is in the current validator set
            address signer = verifyValidatorSignature(rlpHeader, signature);
            bool boolean = false;
            for (uint ii = 0; ii < validatorNumber; ii++) {
                if (signer == validatorSet[ii]) {
                    boolean = true;
                    break;
                }
            }
            require(boolean == true, "The validator of the block is not included in the validator set.");

            //check next 15 blocks. What if the submitter is misbehaving? He can write whatever he wants!

            //if everything is okay, update the validator set
            bytes[] memory newValidatorSet = getValidatorSet(fullHeader.extraData);
            bytes32 hashVS = keccak256(abi.encode(newValidatorSet));
            currentHeight = currentHeight + 200;
            consensusStates[currentHeight] = ConsensusState(hashVS, msg.sender);
            console.log(currentHeight);

        }
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

    //is this function necessary?
    function getValidatorSignature(bytes calldata extraData) external view returns (bytes memory) {
        return bytes(extraData[452:]);
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


