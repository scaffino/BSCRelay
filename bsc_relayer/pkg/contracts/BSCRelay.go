// Code generated - DO NOT EDIT.
// This file is a generated binding and any manual changes will be lost.

package contracts

import (
	"math/big"
	"strings"

	ethereum "github.com/ethereum/go-ethereum"
	"github.com/ethereum/go-ethereum/accounts/abi"
	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/core/types"
	"github.com/ethereum/go-ethereum/event"
)

// Reference imports to suppress errors if they are not otherwise used.
var (
	_ = big.NewInt
	_ = strings.NewReader
	_ = ethereum.NotFound
	_ = bind.Bind
	_ = common.Big1
	_ = types.BloomLookup
	_ = event.NewSubscription
)

// BSCRelayFullHeader is an auto generated low-level Go binding around an user-defined struct.
type BSCRelayFullHeader struct {
	ChainId          *big.Int
	ParentHash       [32]byte
	UncleHash        [32]byte
	Miner            common.Address
	StateRoot        [32]byte
	TransactionsRoot [32]byte
	ReceiptsRoot     [32]byte
	Bloom            []byte
	Difficulty       *big.Int
	BlockNumber      *big.Int
	GasLimit         *big.Int
	GasUsed          *big.Int
	Timestamp        *big.Int
	ExtraData        []byte
	MixHash          [32]byte
	Nonce            *big.Int
}

// BSCRelayABI is the input ABI used to generate the binding from.
const BSCRelayABI = "[{\"inputs\":[{\"internalType\":\"address[]\",\"name\":\"validatorSet\",\"type\":\"address[]\"},{\"internalType\":\"uint64\",\"name\":\"blockHeight\",\"type\":\"uint64\"}],\"stateMutability\":\"nonpayable\",\"type\":\"constructor\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"uint256\",\"name\":\"blockNumber\",\"type\":\"uint256\"}],\"name\":\"EpochBlockSubmitted\",\"type\":\"event\"},{\"inputs\":[{\"internalType\":\"bytes\",\"name\":\"rlpUnsignedHeader\",\"type\":\"bytes\"},{\"internalType\":\"bytes\",\"name\":\"rlpSignedHeader\",\"type\":\"bytes\"}],\"name\":\"compareBlockHeader\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint64\",\"name\":\"\",\"type\":\"uint64\"}],\"name\":\"consensusStates\",\"outputs\":[{\"internalType\":\"bytes32\",\"name\":\"validatorSetHash\",\"type\":\"bytes32\"},{\"internalType\":\"address\",\"name\":\"relayerAddress\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"bytes\",\"name\":\"rlpHeader\",\"type\":\"bytes\"}],\"name\":\"decodeRLPHeader\",\"outputs\":[{\"components\":[{\"internalType\":\"uint256\",\"name\":\"chainId\",\"type\":\"uint256\"},{\"internalType\":\"bytes32\",\"name\":\"parentHash\",\"type\":\"bytes32\"},{\"internalType\":\"bytes32\",\"name\":\"uncleHash\",\"type\":\"bytes32\"},{\"internalType\":\"address\",\"name\":\"miner\",\"type\":\"address\"},{\"internalType\":\"bytes32\",\"name\":\"stateRoot\",\"type\":\"bytes32\"},{\"internalType\":\"bytes32\",\"name\":\"transactionsRoot\",\"type\":\"bytes32\"},{\"internalType\":\"bytes32\",\"name\":\"receiptsRoot\",\"type\":\"bytes32\"},{\"internalType\":\"bytes\",\"name\":\"bloom\",\"type\":\"bytes\"},{\"internalType\":\"uint256\",\"name\":\"difficulty\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"blockNumber\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"gasLimit\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"gasUsed\",\"type\":\"uint256\"},{\"internalType\":\"uint256\",\"name\":\"timestamp\",\"type\":\"uint256\"},{\"internalType\":\"bytes\",\"name\":\"extraData\",\"type\":\"bytes\"},{\"internalType\":\"bytes32\",\"name\":\"mixHash\",\"type\":\"bytes32\"},{\"internalType\":\"uint256\",\"name\":\"nonce\",\"type\":\"uint256\"}],\"internalType\":\"structBSCRelay.FullHeader\",\"name\":\"\",\"type\":\"tuple\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"getLastEpochBlockSubmitted\",\"outputs\":[{\"internalType\":\"uint64\",\"name\":\"\",\"type\":\"uint64\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"bytes\",\"name\":\"extraData\",\"type\":\"bytes\"}],\"name\":\"getValidatorSet\",\"outputs\":[{\"internalType\":\"address[]\",\"name\":\"\",\"type\":\"address[]\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"bytes\",\"name\":\"extraData\",\"type\":\"bytes\"}],\"name\":\"getValidatorSignature\",\"outputs\":[{\"internalType\":\"bytes\",\"name\":\"\",\"type\":\"bytes\"}],\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"bytes[]\",\"name\":\"rlpUnsignedHeaders\",\"type\":\"bytes[]\"},{\"internalType\":\"bytes[]\",\"name\":\"rlpSignedHeaders\",\"type\":\"bytes[]\"},{\"internalType\":\"address[]\",\"name\":\"validatorSet\",\"type\":\"address[]\"}],\"name\":\"submitEpochBlock\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"bytes[]\",\"name\":\"rlpUnsignedHeaders\",\"type\":\"bytes[]\"},{\"internalType\":\"bytes[]\",\"name\":\"rlpSignedHeaders\",\"type\":\"bytes[]\"},{\"internalType\":\"address[]\",\"name\":\"validatorSet\",\"type\":\"address[]\"}],\"name\":\"verifyBlock\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"bytes\",\"name\":\"rlpHeader\",\"type\":\"bytes\"},{\"internalType\":\"bytes\",\"name\":\"signature\",\"type\":\"bytes\"}],\"name\":\"verifyValidatorSignature\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\"}]"

// BSCRelay is an auto generated Go binding around an Ethereum contract.
type BSCRelay struct {
	BSCRelayCaller     // Read-only binding to the contract
	BSCRelayTransactor // Write-only binding to the contract
	BSCRelayFilterer   // Log filterer for contract events
}

// BSCRelayCaller is an auto generated read-only Go binding around an Ethereum contract.
type BSCRelayCaller struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// BSCRelayTransactor is an auto generated write-only Go binding around an Ethereum contract.
type BSCRelayTransactor struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// BSCRelayFilterer is an auto generated log filtering Go binding around an Ethereum contract events.
type BSCRelayFilterer struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// BSCRelaySession is an auto generated Go binding around an Ethereum contract,
// with pre-set call and transact options.
type BSCRelaySession struct {
	Contract     *BSCRelay         // Generic contract binding to set the session for
	CallOpts     bind.CallOpts     // Call options to use throughout this session
	TransactOpts bind.TransactOpts // Transaction auth options to use throughout this session
}

// BSCRelayCallerSession is an auto generated read-only Go binding around an Ethereum contract,
// with pre-set call options.
type BSCRelayCallerSession struct {
	Contract *BSCRelayCaller // Generic contract caller binding to set the session for
	CallOpts bind.CallOpts   // Call options to use throughout this session
}

// BSCRelayTransactorSession is an auto generated write-only Go binding around an Ethereum contract,
// with pre-set transact options.
type BSCRelayTransactorSession struct {
	Contract     *BSCRelayTransactor // Generic contract transactor binding to set the session for
	TransactOpts bind.TransactOpts   // Transaction auth options to use throughout this session
}

// BSCRelayRaw is an auto generated low-level Go binding around an Ethereum contract.
type BSCRelayRaw struct {
	Contract *BSCRelay // Generic contract binding to access the raw methods on
}

// BSCRelayCallerRaw is an auto generated low-level read-only Go binding around an Ethereum contract.
type BSCRelayCallerRaw struct {
	Contract *BSCRelayCaller // Generic read-only contract binding to access the raw methods on
}

// BSCRelayTransactorRaw is an auto generated low-level write-only Go binding around an Ethereum contract.
type BSCRelayTransactorRaw struct {
	Contract *BSCRelayTransactor // Generic write-only contract binding to access the raw methods on
}

// NewBSCRelay creates a new instance of BSCRelay, bound to a specific deployed contract.
func NewBSCRelay(address common.Address, backend bind.ContractBackend) (*BSCRelay, error) {
	contract, err := bindBSCRelay(address, backend, backend, backend)
	if err != nil {
		return nil, err
	}
	return &BSCRelay{BSCRelayCaller: BSCRelayCaller{contract: contract}, BSCRelayTransactor: BSCRelayTransactor{contract: contract}, BSCRelayFilterer: BSCRelayFilterer{contract: contract}}, nil
}

// NewBSCRelayCaller creates a new read-only instance of BSCRelay, bound to a specific deployed contract.
func NewBSCRelayCaller(address common.Address, caller bind.ContractCaller) (*BSCRelayCaller, error) {
	contract, err := bindBSCRelay(address, caller, nil, nil)
	if err != nil {
		return nil, err
	}
	return &BSCRelayCaller{contract: contract}, nil
}

// NewBSCRelayTransactor creates a new write-only instance of BSCRelay, bound to a specific deployed contract.
func NewBSCRelayTransactor(address common.Address, transactor bind.ContractTransactor) (*BSCRelayTransactor, error) {
	contract, err := bindBSCRelay(address, nil, transactor, nil)
	if err != nil {
		return nil, err
	}
	return &BSCRelayTransactor{contract: contract}, nil
}

// NewBSCRelayFilterer creates a new log filterer instance of BSCRelay, bound to a specific deployed contract.
func NewBSCRelayFilterer(address common.Address, filterer bind.ContractFilterer) (*BSCRelayFilterer, error) {
	contract, err := bindBSCRelay(address, nil, nil, filterer)
	if err != nil {
		return nil, err
	}
	return &BSCRelayFilterer{contract: contract}, nil
}

// bindBSCRelay binds a generic wrapper to an already deployed contract.
func bindBSCRelay(address common.Address, caller bind.ContractCaller, transactor bind.ContractTransactor, filterer bind.ContractFilterer) (*bind.BoundContract, error) {
	parsed, err := abi.JSON(strings.NewReader(BSCRelayABI))
	if err != nil {
		return nil, err
	}
	return bind.NewBoundContract(address, parsed, caller, transactor, filterer), nil
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_BSCRelay *BSCRelayRaw) Call(opts *bind.CallOpts, result interface{}, method string, params ...interface{}) error {
	return _BSCRelay.Contract.BSCRelayCaller.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_BSCRelay *BSCRelayRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _BSCRelay.Contract.BSCRelayTransactor.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_BSCRelay *BSCRelayRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _BSCRelay.Contract.BSCRelayTransactor.contract.Transact(opts, method, params...)
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_BSCRelay *BSCRelayCallerRaw) Call(opts *bind.CallOpts, result interface{}, method string, params ...interface{}) error {
	return _BSCRelay.Contract.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_BSCRelay *BSCRelayTransactorRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _BSCRelay.Contract.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_BSCRelay *BSCRelayTransactorRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _BSCRelay.Contract.contract.Transact(opts, method, params...)
}

// CompareBlockHeader is a free data retrieval call binding the contract method 0x6244a007.
//
// Solidity: function compareBlockHeader(bytes rlpUnsignedHeader, bytes rlpSignedHeader) view returns(bool)
func (_BSCRelay *BSCRelayCaller) CompareBlockHeader(opts *bind.CallOpts, rlpUnsignedHeader []byte, rlpSignedHeader []byte) (bool, error) {
	var (
		ret0 = new(bool)
	)
	out := ret0
	err := _BSCRelay.contract.Call(opts, out, "compareBlockHeader", rlpUnsignedHeader, rlpSignedHeader)
	return *ret0, err
}

// CompareBlockHeader is a free data retrieval call binding the contract method 0x6244a007.
//
// Solidity: function compareBlockHeader(bytes rlpUnsignedHeader, bytes rlpSignedHeader) view returns(bool)
func (_BSCRelay *BSCRelaySession) CompareBlockHeader(rlpUnsignedHeader []byte, rlpSignedHeader []byte) (bool, error) {
	return _BSCRelay.Contract.CompareBlockHeader(&_BSCRelay.CallOpts, rlpUnsignedHeader, rlpSignedHeader)
}

// CompareBlockHeader is a free data retrieval call binding the contract method 0x6244a007.
//
// Solidity: function compareBlockHeader(bytes rlpUnsignedHeader, bytes rlpSignedHeader) view returns(bool)
func (_BSCRelay *BSCRelayCallerSession) CompareBlockHeader(rlpUnsignedHeader []byte, rlpSignedHeader []byte) (bool, error) {
	return _BSCRelay.Contract.CompareBlockHeader(&_BSCRelay.CallOpts, rlpUnsignedHeader, rlpSignedHeader)
}

// ConsensusStates is a free data retrieval call binding the contract method 0xe08322d5.
//
// Solidity: function consensusStates(uint64 ) view returns(bytes32 validatorSetHash, address relayerAddress)
func (_BSCRelay *BSCRelayCaller) ConsensusStates(opts *bind.CallOpts, arg0 uint64) (struct {
	ValidatorSetHash [32]byte
	RelayerAddress   common.Address
}, error) {
	ret := new(struct {
		ValidatorSetHash [32]byte
		RelayerAddress   common.Address
	})
	out := ret
	err := _BSCRelay.contract.Call(opts, out, "consensusStates", arg0)
	return *ret, err
}

// ConsensusStates is a free data retrieval call binding the contract method 0xe08322d5.
//
// Solidity: function consensusStates(uint64 ) view returns(bytes32 validatorSetHash, address relayerAddress)
func (_BSCRelay *BSCRelaySession) ConsensusStates(arg0 uint64) (struct {
	ValidatorSetHash [32]byte
	RelayerAddress   common.Address
}, error) {
	return _BSCRelay.Contract.ConsensusStates(&_BSCRelay.CallOpts, arg0)
}

// ConsensusStates is a free data retrieval call binding the contract method 0xe08322d5.
//
// Solidity: function consensusStates(uint64 ) view returns(bytes32 validatorSetHash, address relayerAddress)
func (_BSCRelay *BSCRelayCallerSession) ConsensusStates(arg0 uint64) (struct {
	ValidatorSetHash [32]byte
	RelayerAddress   common.Address
}, error) {
	return _BSCRelay.Contract.ConsensusStates(&_BSCRelay.CallOpts, arg0)
}

// DecodeRLPHeader is a free data retrieval call binding the contract method 0x26410af6.
//
// Solidity: function decodeRLPHeader(bytes rlpHeader) view returns((uint256,bytes32,bytes32,address,bytes32,bytes32,bytes32,bytes,uint256,uint256,uint256,uint256,uint256,bytes,bytes32,uint256))
func (_BSCRelay *BSCRelayCaller) DecodeRLPHeader(opts *bind.CallOpts, rlpHeader []byte) (BSCRelayFullHeader, error) {
	var (
		ret0 = new(BSCRelayFullHeader)
	)
	out := ret0
	err := _BSCRelay.contract.Call(opts, out, "decodeRLPHeader", rlpHeader)
	return *ret0, err
}

// DecodeRLPHeader is a free data retrieval call binding the contract method 0x26410af6.
//
// Solidity: function decodeRLPHeader(bytes rlpHeader) view returns((uint256,bytes32,bytes32,address,bytes32,bytes32,bytes32,bytes,uint256,uint256,uint256,uint256,uint256,bytes,bytes32,uint256))
func (_BSCRelay *BSCRelaySession) DecodeRLPHeader(rlpHeader []byte) (BSCRelayFullHeader, error) {
	return _BSCRelay.Contract.DecodeRLPHeader(&_BSCRelay.CallOpts, rlpHeader)
}

// DecodeRLPHeader is a free data retrieval call binding the contract method 0x26410af6.
//
// Solidity: function decodeRLPHeader(bytes rlpHeader) view returns((uint256,bytes32,bytes32,address,bytes32,bytes32,bytes32,bytes,uint256,uint256,uint256,uint256,uint256,bytes,bytes32,uint256))
func (_BSCRelay *BSCRelayCallerSession) DecodeRLPHeader(rlpHeader []byte) (BSCRelayFullHeader, error) {
	return _BSCRelay.Contract.DecodeRLPHeader(&_BSCRelay.CallOpts, rlpHeader)
}

// GetLastEpochBlockSubmitted is a free data retrieval call binding the contract method 0xebac5f82.
//
// Solidity: function getLastEpochBlockSubmitted() view returns(uint64)
func (_BSCRelay *BSCRelayCaller) GetLastEpochBlockSubmitted(opts *bind.CallOpts) (uint64, error) {
	var (
		ret0 = new(uint64)
	)
	out := ret0
	err := _BSCRelay.contract.Call(opts, out, "getLastEpochBlockSubmitted")
	return *ret0, err
}

// GetLastEpochBlockSubmitted is a free data retrieval call binding the contract method 0xebac5f82.
//
// Solidity: function getLastEpochBlockSubmitted() view returns(uint64)
func (_BSCRelay *BSCRelaySession) GetLastEpochBlockSubmitted() (uint64, error) {
	return _BSCRelay.Contract.GetLastEpochBlockSubmitted(&_BSCRelay.CallOpts)
}

// GetLastEpochBlockSubmitted is a free data retrieval call binding the contract method 0xebac5f82.
//
// Solidity: function getLastEpochBlockSubmitted() view returns(uint64)
func (_BSCRelay *BSCRelayCallerSession) GetLastEpochBlockSubmitted() (uint64, error) {
	return _BSCRelay.Contract.GetLastEpochBlockSubmitted(&_BSCRelay.CallOpts)
}

// GetValidatorSet is a free data retrieval call binding the contract method 0x3ed03d8a.
//
// Solidity: function getValidatorSet(bytes extraData) view returns(address[])
func (_BSCRelay *BSCRelayCaller) GetValidatorSet(opts *bind.CallOpts, extraData []byte) ([]common.Address, error) {
	var (
		ret0 = new([]common.Address)
	)
	out := ret0
	err := _BSCRelay.contract.Call(opts, out, "getValidatorSet", extraData)
	return *ret0, err
}

// GetValidatorSet is a free data retrieval call binding the contract method 0x3ed03d8a.
//
// Solidity: function getValidatorSet(bytes extraData) view returns(address[])
func (_BSCRelay *BSCRelaySession) GetValidatorSet(extraData []byte) ([]common.Address, error) {
	return _BSCRelay.Contract.GetValidatorSet(&_BSCRelay.CallOpts, extraData)
}

// GetValidatorSet is a free data retrieval call binding the contract method 0x3ed03d8a.
//
// Solidity: function getValidatorSet(bytes extraData) view returns(address[])
func (_BSCRelay *BSCRelayCallerSession) GetValidatorSet(extraData []byte) ([]common.Address, error) {
	return _BSCRelay.Contract.GetValidatorSet(&_BSCRelay.CallOpts, extraData)
}

// GetValidatorSignature is a free data retrieval call binding the contract method 0x6db7f026.
//
// Solidity: function getValidatorSignature(bytes extraData) view returns(bytes)
func (_BSCRelay *BSCRelayCaller) GetValidatorSignature(opts *bind.CallOpts, extraData []byte) ([]byte, error) {
	var (
		ret0 = new([]byte)
	)
	out := ret0
	err := _BSCRelay.contract.Call(opts, out, "getValidatorSignature", extraData)
	return *ret0, err
}

// GetValidatorSignature is a free data retrieval call binding the contract method 0x6db7f026.
//
// Solidity: function getValidatorSignature(bytes extraData) view returns(bytes)
func (_BSCRelay *BSCRelaySession) GetValidatorSignature(extraData []byte) ([]byte, error) {
	return _BSCRelay.Contract.GetValidatorSignature(&_BSCRelay.CallOpts, extraData)
}

// GetValidatorSignature is a free data retrieval call binding the contract method 0x6db7f026.
//
// Solidity: function getValidatorSignature(bytes extraData) view returns(bytes)
func (_BSCRelay *BSCRelayCallerSession) GetValidatorSignature(extraData []byte) ([]byte, error) {
	return _BSCRelay.Contract.GetValidatorSignature(&_BSCRelay.CallOpts, extraData)
}

// VerifyValidatorSignature is a free data retrieval call binding the contract method 0x231751fa.
//
// Solidity: function verifyValidatorSignature(bytes rlpHeader, bytes signature) view returns(address)
func (_BSCRelay *BSCRelayCaller) VerifyValidatorSignature(opts *bind.CallOpts, rlpHeader []byte, signature []byte) (common.Address, error) {
	var (
		ret0 = new(common.Address)
	)
	out := ret0
	err := _BSCRelay.contract.Call(opts, out, "verifyValidatorSignature", rlpHeader, signature)
	return *ret0, err
}

// VerifyValidatorSignature is a free data retrieval call binding the contract method 0x231751fa.
//
// Solidity: function verifyValidatorSignature(bytes rlpHeader, bytes signature) view returns(address)
func (_BSCRelay *BSCRelaySession) VerifyValidatorSignature(rlpHeader []byte, signature []byte) (common.Address, error) {
	return _BSCRelay.Contract.VerifyValidatorSignature(&_BSCRelay.CallOpts, rlpHeader, signature)
}

// VerifyValidatorSignature is a free data retrieval call binding the contract method 0x231751fa.
//
// Solidity: function verifyValidatorSignature(bytes rlpHeader, bytes signature) view returns(address)
func (_BSCRelay *BSCRelayCallerSession) VerifyValidatorSignature(rlpHeader []byte, signature []byte) (common.Address, error) {
	return _BSCRelay.Contract.VerifyValidatorSignature(&_BSCRelay.CallOpts, rlpHeader, signature)
}

// SubmitEpochBlock is a paid mutator transaction binding the contract method 0x33f70f67.
//
// Solidity: function submitEpochBlock(bytes[] rlpUnsignedHeaders, bytes[] rlpSignedHeaders, address[] validatorSet) returns()
func (_BSCRelay *BSCRelayTransactor) SubmitEpochBlock(opts *bind.TransactOpts, rlpUnsignedHeaders [][]byte, rlpSignedHeaders [][]byte, validatorSet []common.Address) (*types.Transaction, error) {
	return _BSCRelay.contract.Transact(opts, "submitEpochBlock", rlpUnsignedHeaders, rlpSignedHeaders, validatorSet)
}

// SubmitEpochBlock is a paid mutator transaction binding the contract method 0x33f70f67.
//
// Solidity: function submitEpochBlock(bytes[] rlpUnsignedHeaders, bytes[] rlpSignedHeaders, address[] validatorSet) returns()
func (_BSCRelay *BSCRelaySession) SubmitEpochBlock(rlpUnsignedHeaders [][]byte, rlpSignedHeaders [][]byte, validatorSet []common.Address) (*types.Transaction, error) {
	return _BSCRelay.Contract.SubmitEpochBlock(&_BSCRelay.TransactOpts, rlpUnsignedHeaders, rlpSignedHeaders, validatorSet)
}

// SubmitEpochBlock is a paid mutator transaction binding the contract method 0x33f70f67.
//
// Solidity: function submitEpochBlock(bytes[] rlpUnsignedHeaders, bytes[] rlpSignedHeaders, address[] validatorSet) returns()
func (_BSCRelay *BSCRelayTransactorSession) SubmitEpochBlock(rlpUnsignedHeaders [][]byte, rlpSignedHeaders [][]byte, validatorSet []common.Address) (*types.Transaction, error) {
	return _BSCRelay.Contract.SubmitEpochBlock(&_BSCRelay.TransactOpts, rlpUnsignedHeaders, rlpSignedHeaders, validatorSet)
}

// VerifyBlock is a paid mutator transaction binding the contract method 0x44149d0c.
//
// Solidity: function verifyBlock(bytes[] rlpUnsignedHeaders, bytes[] rlpSignedHeaders, address[] validatorSet) returns(bool)
func (_BSCRelay *BSCRelayTransactor) VerifyBlock(opts *bind.TransactOpts, rlpUnsignedHeaders [][]byte, rlpSignedHeaders [][]byte, validatorSet []common.Address) (*types.Transaction, error) {
	return _BSCRelay.contract.Transact(opts, "verifyBlock", rlpUnsignedHeaders, rlpSignedHeaders, validatorSet)
}

// VerifyBlock is a paid mutator transaction binding the contract method 0x44149d0c.
//
// Solidity: function verifyBlock(bytes[] rlpUnsignedHeaders, bytes[] rlpSignedHeaders, address[] validatorSet) returns(bool)
func (_BSCRelay *BSCRelaySession) VerifyBlock(rlpUnsignedHeaders [][]byte, rlpSignedHeaders [][]byte, validatorSet []common.Address) (*types.Transaction, error) {
	return _BSCRelay.Contract.VerifyBlock(&_BSCRelay.TransactOpts, rlpUnsignedHeaders, rlpSignedHeaders, validatorSet)
}

// VerifyBlock is a paid mutator transaction binding the contract method 0x44149d0c.
//
// Solidity: function verifyBlock(bytes[] rlpUnsignedHeaders, bytes[] rlpSignedHeaders, address[] validatorSet) returns(bool)
func (_BSCRelay *BSCRelayTransactorSession) VerifyBlock(rlpUnsignedHeaders [][]byte, rlpSignedHeaders [][]byte, validatorSet []common.Address) (*types.Transaction, error) {
	return _BSCRelay.Contract.VerifyBlock(&_BSCRelay.TransactOpts, rlpUnsignedHeaders, rlpSignedHeaders, validatorSet)
}

// BSCRelayEpochBlockSubmittedIterator is returned from FilterEpochBlockSubmitted and is used to iterate over the raw logs and unpacked data for EpochBlockSubmitted events raised by the BSCRelay contract.
type BSCRelayEpochBlockSubmittedIterator struct {
	Event *BSCRelayEpochBlockSubmitted // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *BSCRelayEpochBlockSubmittedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(BSCRelayEpochBlockSubmitted)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(BSCRelayEpochBlockSubmitted)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *BSCRelayEpochBlockSubmittedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *BSCRelayEpochBlockSubmittedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// BSCRelayEpochBlockSubmitted represents a EpochBlockSubmitted event raised by the BSCRelay contract.
type BSCRelayEpochBlockSubmitted struct {
	BlockNumber *big.Int
	Raw         types.Log // Blockchain specific contextual infos
}

// FilterEpochBlockSubmitted is a free log retrieval operation binding the contract event 0x197340c981b7f56742613eef83844d90eeb3598004c67c7d29beb309561fb44a.
//
// Solidity: event EpochBlockSubmitted(uint256 indexed blockNumber)
func (_BSCRelay *BSCRelayFilterer) FilterEpochBlockSubmitted(opts *bind.FilterOpts, blockNumber []*big.Int) (*BSCRelayEpochBlockSubmittedIterator, error) {

	var blockNumberRule []interface{}
	for _, blockNumberItem := range blockNumber {
		blockNumberRule = append(blockNumberRule, blockNumberItem)
	}

	logs, sub, err := _BSCRelay.contract.FilterLogs(opts, "EpochBlockSubmitted", blockNumberRule)
	if err != nil {
		return nil, err
	}
	return &BSCRelayEpochBlockSubmittedIterator{contract: _BSCRelay.contract, event: "EpochBlockSubmitted", logs: logs, sub: sub}, nil
}

// WatchEpochBlockSubmitted is a free log subscription operation binding the contract event 0x197340c981b7f56742613eef83844d90eeb3598004c67c7d29beb309561fb44a.
//
// Solidity: event EpochBlockSubmitted(uint256 indexed blockNumber)
func (_BSCRelay *BSCRelayFilterer) WatchEpochBlockSubmitted(opts *bind.WatchOpts, sink chan<- *BSCRelayEpochBlockSubmitted, blockNumber []*big.Int) (event.Subscription, error) {

	var blockNumberRule []interface{}
	for _, blockNumberItem := range blockNumber {
		blockNumberRule = append(blockNumberRule, blockNumberItem)
	}

	logs, sub, err := _BSCRelay.contract.WatchLogs(opts, "EpochBlockSubmitted", blockNumberRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(BSCRelayEpochBlockSubmitted)
				if err := _BSCRelay.contract.UnpackLog(event, "EpochBlockSubmitted", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseEpochBlockSubmitted is a log parse operation binding the contract event 0x197340c981b7f56742613eef83844d90eeb3598004c67c7d29beb309561fb44a.
//
// Solidity: event EpochBlockSubmitted(uint256 indexed blockNumber)
func (_BSCRelay *BSCRelayFilterer) ParseEpochBlockSubmitted(log types.Log) (*BSCRelayEpochBlockSubmitted, error) {
	event := new(BSCRelayEpochBlockSubmitted)
	if err := _BSCRelay.contract.UnpackLog(event, "EpochBlockSubmitted", log); err != nil {
		return nil, err
	}
	return event, nil
}
