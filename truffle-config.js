const { projectId, privateKey, etherscanAPI } = require('./secrets.json');
const HDWalletProvider = require('@truffle/hdwallet-provider');

module.exports = {
  mocha: {
    enableTimeouts: false
  },
  networks: {
    mainnet: {
      provider: () => new HDWalletProvider([privateKey], `https://mainnet.infura.io/v3/${projectId}`),
      network_id: 1,
      gas: 9000000,
      timeoutBlocks: 20000,
      skipDryRun: true, 
      gasPrice: 202000000000
    },
    rinkeby: {
      provider: () => new HDWalletProvider([privateKey], `https://rinkeby.infura.io/v3/${projectId}`),
      network_id: 4,       // Ropsten's id
      gas: 10000000,        // Ropsten has a lower block limit than mainnet
      timeoutBlocks: 20000,  // # of blocks before a deployment times out  (minimum/default: 50)
      skipDryRun: true,     // Skip dry run before migrations? (default: false for public nets )
      gasPrice: 170000000000 // 80 gwei (to get idea of the mainnet deployment cost)
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

  // truffle deploy --network rinkeby
  // truffle run verify NetworkStateGenesis --network rinkeby

  api_keys: {
    etherscan: etherscanAPI
  }

 };