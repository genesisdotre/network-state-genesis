const NetworkStateGenesis = artifacts.require('NetworkStateGenesis')

const ADDR = {
    "rinkeby": {
        multisig: "0x21b3aE2c33605D20E005A56346Ff0C82Bb84fc74", // Gnosis Safe: https://rinkeby.gnosis-safe.io/app/#/safes/0x21b3aE2c33605D20E005A56346Ff0C82Bb84fc74/balances
        WBTC: "0xa8010A0351520229E0783e68484F6fBa95867F60" // Dummy WBTC token for testing: https://rinkeby.etherscan.io/address/0xa8010a0351520229e0783e68484f6fba95867f60#code
    },

    "mainnet": {
        multisig: "0x476f2d18D28FA1a4FC62CE680fA7852524eB820F", // Real Gnosis Safe: https://gnosis-safe.io/app/#/safes/0x476f2d18D28FA1a4FC62CE680fA7852524eB820F
        WBTC: "0x2260fac5e5542a773aa44fbcfedf7c193bc2c599" // Real WBTC: https://etherscan.io/token/0x2260fac5e5542a773aa44fbcfedf7c193bc2c599
    }
}

const cutoffTimestamp = 1625443200; // Mon Jul 05 2021 00:00:00 GMT+0000

module.exports = async function (deployer, network) {
    const addresses = ADDR[network];
    
    console.log("Deploying to network: " + network + " contract addresses are as follows: ", addresses) ;

    await deployer.deploy(NetworkStateGenesis, "Network State Genesis", "NSG", addresses.multisig, addresses.WBTC, cutoffTimestamp);
};