const NetworkStateGenesis = artifacts.require('NetworkStateGenesis')

const ADDR = {
    "test": {
        multisig: "0x21b3aE2c33605D20E005A56346Ff0C82Bb84fc74", // Gnosis Safe: just a random address
    },

    "sepolia": {
        multisig: "0x33BaE12266B212192469d7af663d9D95F0470D2c", // Gnosis Safe: https://sepolia.etherscan.io/address/0x33BaE12266B212192469d7af663d9D95F0470D2c
    },

    "mainnet": {
        multisig: "0x476f2d18D28FA1a4FC62CE680fA7852524eB820F", // Real Gnosis Safe: https://gnosis-safe.io/app/#/safes/0x476f2d18D28FA1a4FC62CE680fA7852524eB820F
    }
}

const cutoffTimestamp = 1625443200; // Mon Jul 05 2021 00:00:00 GMT+0000

module.exports = async function (deployer, network) {
    const addresses = ADDR[network];

    console.log("Deploying to network: " + network + ". Contract addresses are as follows: ", addresses) ;

    await deployer.deploy(NetworkStateGenesis, "Network State Genesis", "NSG", addresses.multisig, cutoffTimestamp);
};