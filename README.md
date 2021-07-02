# BSC<sub>2</sub>ETH relay

This project contains Ethereum smart contracts that enable the verification of blocks of the Binance Smart Chain blockchain (BSC) on the Ethereum blockchain (target blockchain) in a trustless and decentralized way.

This means a user can send a request to the Ethereum chain asking whether or not a certain block has been included in the BSC chain and is verified. 
The Ethereum chain then provides a reliable and truthful answer without relying on any third party trust.  

The blocks relayed to and verified by BSC<sub>2</sub>ETH relay enable Simplified Payment Verification (SPV).

## How it works

### Storage
To reduce the storage costs, for every valid epoch block the fewest data possible are stored in the relay smart contract. The contract only stores:
* The hash of the validator set
* The block height
* The address of the relayer. The user that relayed a valid epoch block E<sub>n</sub> will earn a fee whenever an SPV is requested for a block whose height is comprised between E<sub>n</sub> + N/2 and E<sub>n</sub> + 200 + N/2.


### Block Verification
To verify the validity of an epoch block the relayer has to provide the relay smart contract with: 
* rlp header of the epoch block (signature of the validator excluded)
* signature of the validator
* validator set of the previous epoch block (the addresses will be hashed together and checked against the hash of the validator set stored in the contract)
* rlp header of the next N/2 blocks 

### Validator Set handling
In Binance Smart Chain, a block with a block height multiple of 200 is called an epoch block. Every epoch block contains the 21 validator addresses in the ```extraData``` field. This means that for every epoch block, the validator set can be retrieved from the block header.

Validators set changes take place at the (epoch+N/2) blocks, where N is the size of validator set before the epoch block. In this way, a malicious relayer cannot relay a block with an invalid validator set because s/he will not be able to forge N/2 subsequent valid blocks. 

### Simplified Payment Verification
SPV is a technique that can be used to cryptographically verify that a particular transaction is part of a blockchain while only having knowledge of a blockchain’s block headers and not the individual blockchain transactions. 

BSC<sub>2</sub>ETH relay comes with SPV capabilities so that the incentive mechanism for relayers is enabled. In fact, as previously mentioned, the relayer of a valid epoch block E<sub>n</sub> earns a fee whenever a SPV is requested for those block using the validator set of E<sub>n</sub>.

### Finality


### Further improvements 
Since at the time of writing the validator set update takes place only once per day (every night at 00:00 UTC), the relay can be optimized to store only one block per day, namely the first epoch block mined right after midnight containing the validator set update. 

In this way, the chances for relayers to get a fee are also increased.

### References
- [Binance Chain Whitepaper](https://github.com/binance-chain/whitepaper/blob/master/WHITEPAPER.md)
- [Binance Chain Docs](https://docs.binance.org/smart-chain/guides/bsc-intro.html)
- [Binance Smart Chain github](https://github.com/binance-chain/bsc)

