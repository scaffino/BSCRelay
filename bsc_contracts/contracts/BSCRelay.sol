pragma solidity >=0.7.0 <0.9.0;
pragma experimental ABIEncoderV2; //returning struct is not fully supported. I need this line to enable it

import "hardhat/console.sol";
import "./RLPReader.sol";
import "./ECDSA.sol";

contract BSCRelay {

    using RLPReader for *;

    struct ConsensusState {
        mapping(address => bool) ValidatorSet;
        address relayerAddress; //address that receives the fee
    }

    //uint64 is the blockHeight
    mapping(uint64 => ConsensusState) public consensusStates;
    uint extraVanity = 32; // Fixed number of extra-data prefix bytes reserved for signer vanity
    uint extraSeal = 65; // Fixed number of extra-data suffix bytes reserved for signer seal

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

    // initial VS, initial height, no full block as we have now
    // I have to pass the parameters to the test when I deploy it
    /*constructor (bytes memory _rlpHeader, uint totalDifficulty) {
        bytes32 newBlockHash = keccak256(_rlpHeader);

        FullHeader memory parsedHeader = parseRlpEncodedHeader(_rlpHeader);
        Header memory newHeader;

        newHeader.hash = newBlockHash;
        newHeader.blockNumber = uint24(parsedHeader.blockNumber);
        newHeader.totalDifficulty = uint232(totalDifficulty);
        newHeader.meta.forkId = maxForkId;  // the first block is no fork (forkId = 0)
        iterableEndpoints.push(newBlockHash);
        newHeader.meta.iterableIndex = uint64(iterableEndpoints.length - 1);    // the first block is also an endpoint
        newHeader.meta.lockedUntil = uint64(block.timestamp);   // the first block does not need a confirmation period

        headers[newBlockHash] = newHeader;

        longestChainEndpoint = newBlockHash;    // the first block is also the longest chain/fork at the moment

        genesisBlockHash = newBlockHash;
    }*/

    //rlpHeader without validator signature
    function verifyHeader(bytes memory rlpHeader, bytes memory signature) external view returns(uint) {
        uint errorCode = 0;
        FullHeader memory fullHeader = parseRlpEncodedHeader(rlpHeader);

        //console.log(rlpHeader.length);
        require(fullHeader.mixHash == 0x0000000000000000000000000000000000000000000000000000000000000000, "mixHash must be 0x0000000000000000000000000000000000000000000000000000000000000000");
        require(fullHeader.difficulty == 2 || fullHeader.difficulty == 1, "difficulty incorrect");
        require(fullHeader.blockNumber != 0, "You can't submit the genesis block");

        return errorCode;
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
    function getValidatorSet(bytes calldata extraData) external view returns(bytes[] memory){
        uint start = 32;
        bytes[] memory validatorSet = new bytes[](21);
        for (uint ii = 0; ii < 21; ii++){
            validatorSet[ii] = bytes(extraData[start:(start+20)]);
            start += 20;
        }

        return validatorSet;
    }

    //is this function necessary?
    function getValidatorSignature(bytes calldata extraData) external view returns (bytes memory) {
        return bytes(extraData[452:]);
    }

    //rlpHeader without validator signature
    function verifyValidatorSignature(bytes memory rlpHeader, bytes memory signature) external view returns(address){
        bytes32 hashRLPHeader = keccak256(rlpHeader);
        console.logBytes32(hashRLPHeader);
        return ECDSA.recover(hashRLPHeader, signature);
    }

    function parseRlpEncodedHeader(bytes memory rlpHeader) private view returns (FullHeader memory) {
        FullHeader memory header;

        RLPReader.Iterator memory it = rlpHeader.toRlpItem().iterator();
            uint idx;
            while(it.hasNext()) {
                if( idx == 0 ) {header.chainId = it.next().toUint(); console.log(header.chainId);}
                else if( idx ==  1) {header.parentHash = bytes32(it.next().toUint());console.logBytes32(header.parentHash);}
                else if ( idx == 2 ) {header.uncleHash = bytes32(it.next().toUint());console.logBytes32(header.uncleHash);}
                else if ( idx == 3 ) {header.miner = address(it.next().toUint());console.logAddress(header.miner);}
                else if ( idx == 4 ) {header.stateRoot = bytes32(it.next().toUint());console.logBytes32(header.stateRoot);}
                else if ( idx == 5 ) {header.transactionsRoot = bytes32(it.next().toUint());console.logBytes32(header.transactionsRoot);}
                else if ( idx == 6 ) {header.receiptsRoot = bytes32(it.next().toUint());console.logBytes32(header.receiptsRoot);}
                else if ( idx == 7 ) {header.bloom = it.next().toBytes();console.logBytes(header.bloom);}
                else if ( idx == 8 ) {header.difficulty = it.next().toUint();console.log(header.difficulty);}
                else if ( idx == 9 ) {header.blockNumber = it.next().toUint();console.log(header.blockNumber);}
                else if ( idx == 10 ){ header.gasLimit = it.next().toUint();console.log(header.gasLimit);}
                else if ( idx == 11 ) {header.gasUsed = it.next().toUint();console.log(header.gasUsed);}
                else if ( idx == 12 ) {header.timestamp = it.next().toUint();console.log(header.timestamp);}
                else if ( idx == 13 ) {header.extraData = it.next().toBytes();console.logBytes(header.extraData);}
                else if ( idx == 14 ) {header.mixHash = bytes32(it.next().toUint());console.logBytes32(header.mixHash);}
                else if ( idx == 15 ) {header.nonce = it.next().toUint();console.log(header.nonce);}
                else it.next();

                idx++;
            }

        return header;
    }
}


