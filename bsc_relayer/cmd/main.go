package main

import (
	"bsc_relayer/pkg/utils"
	"context"
	"fmt"
	"github.com/binance-chain/bsc-go-client/client"
	"github.com/ethereum/go-ethereum/common"
	"math/big"
)

func main() {

	var c, _ = client.Dial("wss://bsc-ws-node.nariox.org:443")
	header,err := c.HeaderByNumber(context.Background(),big.NewInt(8375600))

	if err != nil{
		panic(err)
	}

	headerJSON, err := header.MarshalJSON()
	if err != nil{
		panic(err)
	}

	headerRLP, err := utils.EncodeHeaderToRLP(header)
	if err != nil{
		panic(err)
	}

	fmt.Println(string(headerJSON))
	fmt.Println(common.Bytes2Hex(headerRLP))
}



