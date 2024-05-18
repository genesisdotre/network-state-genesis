// SPDX-License-Identifier: MIT
pragma solidity 0.8.3;
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NetworkStateGenesis is ERC721, Ownable {
    string public GENESIS; // Preserving consciousness of the moment
    string public _tokenURI;
    uint256 public currentPrice = 7 * (10 ** 15); // Starting price is 0.007 ETH (1/10th of ETH mainnet price)
   	uint256 public currentSerialNumber = 128;
    uint256 public cutoffTimestamp;  // Initially all have the same price. Later on (1625443200 ---> 2021-07-05T00:00:00.000Z) the 0.1% increase kicks in
  	uint256 public multiplier = 1001; 
  	uint256 public divisor = 1000; // Doing math in ETH. Multiply by 1001. Divide by 1000. Effectively 0.1% increase with each purchase
  	event Purchase(address indexed addr, uint256 indexed currentSerialNumber, uint256 price, bool BTC); // Final parameter `BTC` to indicate if purchase with BTC

    address payable public multisig; // Ensure you are comfortable with m-of-n signatories on Gnosis Safe (don't trust, verify)

    constructor(string memory name, string memory symbol, address payable _multisig, uint _cutoffTimestamp) ERC721(name, symbol) {
        require(_multisig != address(0), "multisig has be set up");

        multisig = _multisig;
        cutoffTimestamp = _cutoffTimestamp;

        for (uint i=0; i<128; i++) {
            _mint(multisig, i); 
        }
    }

    // 1. Deploy 2. Include the smart contract address in the PDF. 3. Save IPFS hash in this method.
    function setGenesis(string memory IPFSURI) public onlyOwner {
        require(bytes(GENESIS).length == 0, "GENESIS can be set only once"); // https://ethereum.stackexchange.com/a/46254/2524
        GENESIS = IPFSURI;
    }

    function setTokenURI(string memory URI) public onlyOwner {
        require(bytes(_tokenURI).length == 0, "_tokenURI can be set only once");
        _tokenURI = URI;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        return _tokenURI;
    }
 
    receive() external payable { // Fallback function
        purchase();
    }

    function purchase() payable public {
        require(msg.value >= currentPrice, "Not enough ETH. Check the current price.");
        uint256 refund = msg.value - currentPrice;
        if (refund > 0) {
            (bool sent1, bytes memory data1) = payable(msg.sender).call{value: refund}("");
            require(sent1, "Failed to send ETH refund to the sender");
        }       

        // Sending to Gnosis Safe takes more than 21k gas limit on `transfer`
        // Need to use something else, see: https://solidity-by-example.org/sending-ether/
        (bool sent2, bytes memory data2) = multisig.call{value: currentPrice}("");
        require(sent2, "Failed to send ETH to the multisig");

        _mint(msg.sender, currentSerialNumber);
        emit Purchase(msg.sender, currentSerialNumber, currentPrice, false);
        currentSerialNumber++;

        if (block.timestamp > cutoffTimestamp) {
            currentPrice = currentPrice * multiplier / divisor; // * 1001 / 1000 === increase by 0.1% (no longer SafeMath, compiler by default)
        }
    }

    
}