package utils

import (
	"bytes"
	"fmt"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/core/types"
	"github.com/ethereum/go-ethereum/rlp"
	"math/big"
)

func EncodeHeaderToRLP_EpochBlock(header *types.Header, chainId *big.Int) ([]byte, error) {
	buffer := new(bytes.Buffer)

	err := rlp.Encode(buffer, []interface{}{
		chainId,
		header.ParentHash,
		header.UncleHash,
		header.Coinbase,
		header.Root,
		header.TxHash,
		header.ReceiptHash,
		header.Bloom,
		header.Difficulty,
		header.Number,
		header.GasLimit,
		header.GasUsed,
		header.Time,
		header.Extra[:452],
		header.MixDigest,
		header.Nonce,
	})

	//fmt.Println("extra ----> " + common.Bytes2Hex(header.Extra[:452]));
	fmt.Println("sign ----> " + common.Bytes2Hex(header.Extra[452:517]));

	// be careful when passing byte-array as buffer, the pointer can change if the buffer is used again
	return buffer.Bytes(), err
}

func EncodeHeaderToRLP_noEpochBlock(header *types.Header, chainId *big.Int) ([]byte, error) {
	buffer := new(bytes.Buffer)

	err := rlp.Encode(buffer, []interface{}{
		chainId,
		header.ParentHash,
		header.UncleHash,
		header.Coinbase,
		header.Root,
		header.TxHash,
		header.ReceiptHash,
		header.Bloom,
		header.Difficulty,
		header.Number,
		header.GasLimit,
		header.GasUsed,
		header.Time,
		header.Extra[:32],
		header.MixDigest,
		header.Nonce,
	})

	//fmt.Println("extra ----> " + common.Bytes2Hex(header.Extra[:32]));
	fmt.Println("sign ----> " + common.Bytes2Hex(header.Extra[32:97]));

	// be careful when passing byte-array as buffer, the pointer can change if the buffer is used again
	return buffer.Bytes(), err
}


