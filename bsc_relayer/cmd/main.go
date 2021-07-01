package main

import (
	"bsc_relayer/pkg/utils"
	"context"
	"fmt"
	"github.com/binance-chain/bsc-go-client/client"
	"github.com/ethereum/go-ethereum/common"
	"math/big"
	"os"
	"strconv"
)

func main() {

	blockNumber, err := strconv.Atoi(os.Args[1])

	var c, _ = client.Dial("wss://bsc-ws-node.nariox.org:443")
	header,err := c.HeaderByNumber(context.Background(),big.NewInt(int64(blockNumber)))

	if err != nil{
		panic(err)
	}

	headerJSON, err := header.MarshalJSON()
	if err != nil{
		panic(err)
	}

		headerRLP, err := utils.EncodeHeaderToRLP(header, big.NewInt(56)) //56 is mainnet
		if err != nil{
			panic(err)
		}

		fmt.Println("JSON header -----> " + string(headerJSON))
		fmt.Println("RLP header -----> " + common.Bytes2Hex(headerRLP))

}



