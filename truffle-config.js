const { projectId, privateKey, etherscanAPI } = require('./secrets.json');
const HDWalletProvider = require('@truffle/hdwallet-provider');

module.exports = {
  mocha: {
    enableTimeouts: false
  },
  networks: {
    // TODO: ARBITRUM HERE
    // mainnet: {
    //   provider: () => new HDWalletProvider([privateKey], `https://mainnet.infura.io/v3/${projectId}`),
    //   network_id: 1,
    //   gas: 9000000,
    //   timeoutBlocks: 20000,
    //   skipDryRun: true, 
    //   gasPrice: 202000000000
    // },
    sepolia: {
      provider: () => new HDWalletProvider([privateKey], `https://sepolia.infura.io/v3/${projectId}`),
      // provider: () => new HDWalletProvider([privateKey], `https://eth-sepolia.g.alchemy.com/v2/-T9BRNyVyymLfcu447YlPJQNOpPD0UAf`),
      network_id: 11155111,
      gas: 5500000,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true
    },
   },

  // Configure your compilers
  compilers: {
    solc: {
      version: "0.8.3",    // Fetch exact version from solc-bin (default: truffle's version)
      settings: {          // See the solidity docs for advice about optimization and evmVersion
       optimizer: {
         enabled: true,
         runs: 200
       },
      }
    },
  },

  plugins: [
    'truffle-plugin-verify' 
  ],

  // truffle deploy --network sepolia
  // truffle run verify NetworkStateGenesis --network sepolia

  api_keys: {
    etherscan: etherscanAPI
  }

 };