const PRIVATE_KEY = "a58aa0760cc92d52959fefca1982712e6408d98b7a7fad7796d16f90915145ff";

module.exports = {
  defaultNetwork: "goerli",
  networks: {
    hardhat: {
    },
    goerli: {
      url: "https://eth-goerli.alchemyapi.io/v2/123abc123abc123abc123abc123abcde",
      accounts: [PRIVATE_KEY]
    },
    bsctest: {
      url: "https://data-seed-prebsc-1-s1.binance.org:8545/",
      accounts: [PRIVATE_KEY]
    }
  },
  solidity: {
    version: "0.8.17",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts"
  },
  mocha: {
    timeout: 40000
  }
}