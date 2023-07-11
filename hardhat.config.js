require("@nomicfoundation/hardhat-toolbox");

const PRIVATE_KEY = "c904cad31154e3651a36dc7ea69b39c0d6e34ebe7ee3021a10a9e38ad7d10383";
const etherscanKey = "JWWZ4FI5B2WCHSU9INPUNXXFPPXZA93FD2"
const bscscanKey = "9SWZ3CGU5WVTJK9QNCP5A7TRZ6PUHDE6PH"
const avaxscanKey = "JT49Q5ET22QQR3X1WQV3UH1BEGUWQDJ785"

module.exports = {
  defaultNetwork: "hardhat",
  networks: {
    bsctest: {
      url: "https://data-seed-prebsc-1-s1.binance.org:8545/",
      accounts: [PRIVATE_KEY]
    },
    fuji: {
      url: "https://api.avax-test.network/ext/bc/C/rpc",
      accounts: [PRIVATE_KEY]
    },
    hardhat: {
      
    },
    goerli: {
      url: "https://eth-goerli.alchemyapi.io/v2/123abc123abc123abc123abc123abcde",
      accounts: [PRIVATE_KEY]
    }
  },
  solidity: {
    // version: "0.8.17",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    },
    compilers: [
      {
        version: "0.8.9",
      },
      {
        version: "0.8.0",
      },]
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts"
  },
  mocha: {
    timeout: 40000
  },
  etherscan: {
    apiKey: avaxscanKey,
  },
  bscscan: {
    apiKey: bscscanKey
  }
}