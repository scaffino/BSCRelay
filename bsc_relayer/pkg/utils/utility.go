package utils

import (
	"bytes"
	"fmt"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/core/types"
	"github.com/ethereum/go-ethereum/rlp"
)

func EncodeHeaderToRLP(header *types.Header) ([]byte, error) {
	buffer := new(bytes.Buffer)

	err := rlp.Encode(buffer, []interface{}{
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
		//header.Extra[:452],
		append(header.Extra[:452], make([]byte, 65, 65)...),
		header.MixDigest,
		header.Nonce,
	})

	fmt.Println("extra ----> " + common.Bytes2Hex(header.Extra[:452]));

	// be careful when passing byte-array as buffer, the pointer can change if the buffer is used again
	return buffer.Bytes(), err
}
