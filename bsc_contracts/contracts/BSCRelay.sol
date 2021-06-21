pragma solidity >=0.7.0 <0.9.0;
pragma experimental ABIEncoderV2; //returning struct is not fully supported. I need this line to enable it

import "hardhat/console.sol";
import "./RLPReader.sol";
import "./ECDSA.sol";

contract BSCRelay {

    using RLPReader for *;

    struct MetaInfo {
        uint64 iterableIndex;       // index at which the block header is/was stored in the iterable endpoints array
        uint64 forkId;              // every branch gets a branchId/forkId, stored to speed up block-search/isPartOfMainChain-reqeuests etc.
        uint64 lockedUntil;         // timestamp until which it is possible to dispute a given block
        bytes32 latestFork;         // contains the hash of the latest node where the current fork branched off
        address submitter;          // address of the submitter of the block, stored for incentive and punishment reasons
        bytes32[] successors;       // in case of forks a blockchain can have multiple successors
    }

    // for proving inclusion etc. only the header and some meta-info is stored. The FullHeader space consumption is high and emitting it once is cheaper than save it in the state
    struct Header {
        // uint24 first and uint232 second to pack variables in 1 uint256 variable
        uint24 blockNumber;
        uint232 totalDifficulty;
        bytes32 hash;
        MetaInfo meta;
    }

    // FullHeader
    struct FullHeader {
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

    bytes32 genesisBlockHash;                       // saves the hash of the genesis block the contract was deployed with
    // maybe the saving of the genesis block could also be achieved with events in the
    // constructor that gives very small savings
    mapping (bytes32 => Header) private headers;    // holds all block in a hashmap, key=blockhash, value=reduced block headers with metadata

    // initial VS, initial height, no ful block as we have now
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

    function getValidatorSet(bytes calldata extraData) external view returns(bytes[] memory){
        uint start = 32;
        bytes[] memory validatorSet = new bytes[](21);
        for (uint ii = 0; ii < 21; ii++){
            validatorSet[ii] = bytes(extraData[start:(start+20)]);
            start += 20;
            //console.logBytes(validatorSet[ii]);
        }

        return validatorSet;
    }

    function getValidatorSignature(bytes calldata extraData) external view returns (bytes memory) {
        return bytes(extraData[452:]);
    }

    function verifyValidatorSignature(bytes memory rlpHeader, bytes memory signature) external returns(address){
        bytes32 hashRLPHeader = keccak256(rlpHeader);
        console.log("----");
        console.logBytes32(hashRLPHeader);
        console.logAddress(ECDSA.recover(hashRLPHeader, signature));
        console.log("----");
        hashRLPHeader = ECDSA.toEthSignedMessageHash(hashRLPHeader);
        console.logBytes32(hashRLPHeader);
        console.logAddress(ECDSA.recover(hashRLPHeader, signature));

        //address signerAddress = ecrecover(bytes32 hashRLPHeader, uint8 v, bytes32 r, bytes32 s) returns (address);
        console.log("----");
        return ECDSA.recover(hashRLPHeader, signature);
    }

    function parseRlpEncodedHeader(bytes memory rlpHeader) private pure returns (FullHeader memory) {
        FullHeader memory header;

        RLPReader.Iterator memory it = rlpHeader.toRlpItem().iterator();
        uint idx;
        while(it.hasNext()) {
            if( idx == 0 ) header.parentHash = bytes32(it.next().toUint());
            else if ( idx == 1 ) header.uncleHash = bytes32(it.next().toUint());
            else if ( idx == 2 ) header.miner = address(it.next().toUint());
            else if ( idx == 3 ) header.stateRoot = bytes32(it.next().toUint());
            else if ( idx == 4 ) header.transactionsRoot = bytes32(it.next().toUint());
            else if ( idx == 5 ) header.receiptsRoot = bytes32(it.next().toUint());
            else if ( idx == 6 ) header.bloom = it.next().toBytes();
            else if ( idx == 7 ) header.difficulty = it.next().toUint();
            else if ( idx == 8 ) header.blockNumber = it.next().toUint();
            else if ( idx == 9 ) header.gasLimit = it.next().toUint();
            else if ( idx == 10 ) header.gasUsed = it.next().toUint();
            else if ( idx == 11 ) header.timestamp = it.next().toUint();
            else if ( idx == 12 ) header.extraData = it.next().toBytes();
            else if ( idx == 13 ) header.mixHash = bytes32(it.next().toUint());
            else if ( idx == 14 ) header.nonce = it.next().toUint();
            else it.next();

            idx++;
        }

        return header;
    }
}


