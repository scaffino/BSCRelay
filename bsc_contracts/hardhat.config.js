/**
 * @type import('hardhat/config').HardhatUserConfig
 */

require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-waffle");
require("hardhat-gas-reporter");

module.exports = {
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {},
    ropsten: {
      url: "https://eth-ropsten.alchemyapi.io/v2/B9ctAGI1bCboamSzQE58Xu8b0MPFK_C1",
      accounts: [
        "846477feec0688dc6aa53d05bb4824fb1105f0f2c377e0d78fbde16dd99619ac",
      ],
    },
  },
  solidity: "0.7.3",
};