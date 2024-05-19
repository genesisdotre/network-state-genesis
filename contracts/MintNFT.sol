// SPDX-License-Identifier: MIT
pragma solidity 0.8.3;
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";

interface INetworkStateGenesis { // No need for full ERC721, just minting
    function mint(address to, uint256 tokenId) external;
}

contract MintNFT is Ownable {

    uint256 public currentPrice = 7 * (10 ** 15); // Starting price is 0.007 ETH (1/10th of the V1 price)
   	uint256 public currentSerialNumber = 128;
    uint256 public cutoffTimestamp; // Initially all have the same price. Later on the 0.5% increase kicks in
  	uint256 public multiplier = 1005; 
  	uint256 public divisor = 1000; // Doing math in ETH. Multiply by 1005. Divide by 1000. Effectively 0.5% increase with each purchase
  	event Purchase(address addr, uint256 currentSerialNumber, uint256 price);

    address payable public multisig; // Ensure you are comfortable with m-of-n signatories on Gnosis Safe (don't trust, verify)
    INetworkStateGenesis public NetworkStateGenesis;

    constructor(address _multisig, uint256 _cutoffTimestamp) {
        multisig = payable(_multisig);
        cutoffTimestamp = _cutoffTimestamp;
    }

    // 1. Deploy MintNFT contract
    // 2. Deploy Network State Genesis (pass the MintNFT address in the constructor)
    // 3. Set the address of Network State Genesis in MintNFT contract
    // This is to avoid Metamask warning: https://community.metamask.io/t/whitelist-of-token-contract-addresses-that-legitimately-accept-eth/28963

    function setNetworkStateGenesis(address NetworkStateGenesisAddress) public onlyOwner {
        require(NetworkStateGenesisAddress == address(0), "NetworkStateGenesis can be set only once");
        NetworkStateGenesis = INetworkStateGenesis(NetworkStateGenesisAddress);

        for (uint i=0; i<128; i++) { // Keeping low serial numbers to distribute later on
            NetworkStateGenesis.mint(multisig, i); 
        }
    }
 
    receive() external payable { // Fallback function
        purchase();
    }

    function purchase() payable public {
        require(msg.value >= currentPrice, "Not enough ETH. Check the current price.");
        uint256 refund = msg.value - currentPrice;
        if (refund > 0) {
            (bool sent1,) = payable(msg.sender).call{value: refund}("");
            require(sent1, "Failed to send ETH refund to the sender");
        }       

        // Sending to Gnosis Safe takes more than 21k gas limit on `transfer`
        // Need to use something else, see: https://solidity-by-example.org/sending-ether/
        (bool sent2,) = multisig.call{value: currentPrice}("");
        require(sent2, "Failed to send ETH to the multisig");

        NetworkStateGenesis.mint(msg.sender, currentSerialNumber);
        emit Purchase(msg.sender, currentSerialNumber, currentPrice);
        currentSerialNumber++;

        if (block.timestamp > cutoffTimestamp) {
            currentPrice = currentPrice * multiplier / divisor; // * 1001 / 1000 === increase by 0.1% (no longer SafeMath, compiler by default)
        }
    }

}