const { expectThrow, increaseTime, latestTime, toWei, fromWei } = require('./helpers');

const NSG = artifacts.require('NetworkStateGenesis')
const Minter = artifacts.require('MintNFT')

contract('Network State Genesis', async function(accounts) {

    const creator = accounts[0]
    const guy1 = accounts[1];
    const guy2 = accounts[2];
    const guy3 = accounts[3];
    const guy4 = accounts[4];
    const beneficiary = accounts[5];

    const days = 24 * 60 * 60;
    const GAS_MARGIN = 0.01 * 10e18;

    let nsg;
    let minter;
    
    beforeEach(async() => {
        minter = await Minter.new("0x21b3aE2c33605D20E005A56346Ff0C82Bb84fc74", 1716246000, { from: creator });
        nsg = await NSG.new("Network State Genesis", "NSG", minter.address, { from: creator });     
    })

    it('Can purchase NFT with ETH', async() => {
        console.log("1");
        await minter.sendTransaction({ value: toWei("0.007"), from: guy1 });
        console.log("2");
        let balanceAfterBeneficiary = await web3.eth.getBalance(beneficiary);
        assert.equal(balanceAfterBeneficiary.toString(), toWei("100.007"), "Beneficiary should have 100.07 ETH after the NFT purchase");

        let owner = await nsg.ownerOf(128);
        assert.equal(owner, guy1, "It should be guy1 who owns the NFT with the ID 128");

        // await expectThrow( nsg.sendTransaction({ value: toWei("0.1"), from: guy2 }) ); // too little, price increased by 0.1%
        await minter.sendTransaction({ value: toWei("0.2"), from: guy2 });
        let balanceAfterGuy2 = await web3.eth.getBalance(guy2);

        assert.closeTo(parseFloat(balanceAfterGuy2.toString()), parseFloat(toWei("99.993")), GAS_MARGIN, "Guy2 should receive a refund");

        owner = await nsg.ownerOf(129);
        assert.equal(owner, guy2, "It should be guy2 who owns the NFT with the ID 129");

        // Single person can buy more than 1
        await minter.sendTransaction({ value: toWei("0.007"), from: guy1 });
        let howMany = await nsg.balanceOf.call(guy1);
        assert.equal(howMany, 2, "Guy 1 should have exactly 2 tokens.");

    });

    // it('Can refund ETH when sent too much', async () => {
    //     let balanceBefore = await web3.eth.getBalance(guy1);
    //     await nsg.sendTransaction({ value: toWei("10"), from: guy1 });
    //     let balanceAfter = await web3.eth.getBalance(guy1);
    //     assert.closeTo(parseFloat(balanceBefore.toString()) - toWei("0.007"), parseFloat(balanceAfter.toString()), GAS_MARGIN, "Guy 1 should receive refund (rather than spending 10 ETH");

    // });

    // it('Should throw when sent too little', async() => {
    //     await expectThrow( nsg.sendTransaction({ value: toWei("0.006"), from: guy1 }) );
    
    // });

    // it('Price increase after 4th of July', async() => {
    //     await nsg.sendTransaction({ value: toWei("0007"), from: guy1 });
    //     await increaseTime(1000 * days);
    //     await nsg.sendTransaction({ value: toWei("0.007"), from: guy1 }); // that should still work, first after deadline, price hasn't increased

    //     await expectThrow(nsg.sendTransaction({ value: toWei("0.007"), from: guy1 })); 

    //     let balanceAfter = await nsg.balanceOf.call(guy1);

    //     console.log(balanceAfter.toString());

    //     console.log("GUY1 should have only 2 ^^^^");
    // })

  })