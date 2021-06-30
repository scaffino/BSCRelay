pragma solidity >=0.7.0 <0.9.0;
pragma experimental ABIEncoderV2; //returning struct is not fully supported. I need this line to enable it

import "hardhat/console.sol";
import "./RLPReader.sol";
import "./ECDSA.sol";
import "./ECVerify.sol";

contract BSCRelay {

    using RLPReader for *;

    struct ConsensusState {
        mapping(address => bool) ValidatorSet;
        address relayerAddress; //address that receives the fee
    }

    //uint64 is the blockHeight
    mapping(uint64 => ConsensusState) public consensusStates;

    // FullHeader without validator signature
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

    function verifyHeader (bytes memory rlpHeader) external view returns (bool) {
        bool isValid = true;
        FullHeader memory fullHeader = parseRlpEncodedHeader(rlpHeader);

        if (fullHeader.blockNumber == 0) {
            return "Block Number missing";
        }

/*
        // Don't waste time checking blocks from the future
        if header.Time > uint64(time.Now().Unix()) {
        return consensus.ErrFutureBlock
        }
        // Check that the extra-data contains the vanity, validators and signature.
        if len(header.Extra) < extraVanity {
        return errMissingVanity
        }
        if len(header.Extra) < extraVanity+extraSeal {
        return errMissingSignature
        }
        // check extra data
        isEpoch := number%p.config.Epoch == 0

        // Ensure that the extra-data contains a signer list on checkpoint, but none otherwise
        signersBytes := len(header.Extra) - extraVanity - extraSeal
        if !isEpoch && signersBytes != 0 {
        return errExtraValidators
        }

        if isEpoch && signersBytes%validatorBytesLength != 0 {
        return errInvalidSpanValidators
        }

        // Ensure that the mix digest is zero as we don't have fork protection currently
        if header.MixDigest != (common.Hash{}) {
        return errInvalidMixDigest
        }
        // Ensure that the block doesn't contain any uncles which are meaningless in PoA
        if header.UncleHash != uncleHash {
        return errInvalidUncleHash
        }
        // Ensure that the block's difficulty is meaningful (may not be correct at this point)
        if number > 0 {
        if header.Difficulty == nil {
        return errInvalidDifficulty
        }
        }
        // If all checks passed, validate any special fields for hard forks
        if err := misc.VerifyForkHashes(chain.Config(), header, false); err != nil {
        return err
        }
        // All basic checks passed, verify cascading fields
        return p.verifyCascadingFields(chain, header, parents)*/

        return isValid;
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


