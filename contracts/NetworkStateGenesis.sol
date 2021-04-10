// SPDX-License-Identifier: MIT
pragma solidity 0.8.3;
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NetworkStateGenesis is ERC721 {
    string public GENESIS = "Will be populated";
    uint256 public currentPrice = 7 * (10 ** 16); // Starting price is 0.07 ETH
   	uint256 public currentSerialNumber;
    uint256 public cutoffTimestamp;  // Initially all have the same price. Later on (1625443200 ---> 2021-07-05T00:00:00.000Z) the 0.1% increase kicks in.
  	uint256 public multiplier = 1001; 
  	uint256 public divisor = 1000; // Doing math in ETH. Multiply by 1001. Divide by 1000. Effectively 0.1% increase with each purchase.
  	event Purchase(address indexed addr, uint256 indexed currentSerialNumber, uint256 price, bool BTC); // Final parameter `BTC` to indicate if purchase with BTC
    address public WBTCaddress; // On mainnet: 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599
    IERC20 private WBTC;
    address payable public multisig; // Ensure that there is enough m-of-n signatories and you are one of them to be extra sure (don't trust, verify)

    constructor(string memory name, string memory symbol, address payable _multisig, address _WBTCaddress, uint _cutoffTimestamp) ERC721(name, symbol) {
        multisig = _multisig;
        cutoffTimestamp = _cutoffTimestamp;
        WBTCaddress = _WBTCaddress;
        WBTC = IERC20(WBTCaddress);
    }

    function _baseURI() internal pure override returns (string memory) {
        return "https://genesis.re/passports/";
    }
 
    receive() external payable { // Fallback function
        purchase();
    }

    function purchase() payable public {
        require(msg.value >= currentPrice, "Not enough ETH. Check the current price.");
        uint256 refund = msg.value - currentPrice;
        if (refund > 0) {
            payable(msg.sender).transfer(refund);
        }       
        // multisig.transfer(currentPrice); 

        // Sending to Gnosis Safe takes more than 21k gas limit on `transfer`
        // Need to use something else, see: https://solidity-by-example.org/sending-ether/
        (bool sent, bytes memory data) = multisig.call{value: currentPrice}("");
        require(sent, "Failed to send Ether");

        _mint(msg.sender, currentSerialNumber);
        emit Purchase(msg.sender, currentSerialNumber, currentPrice, false);
        currentSerialNumber++;

        if (block.timestamp > cutoffTimestamp) {
            currentPrice = currentPrice * multiplier / divisor; // * 1001 / 1000 === increase by 0.1% (no longer SafeMath, compiler by default)
        }
    }

    // This is inspired by Hackers Congress Paralelní Polis: final ticket available for 1 BTC
    // Network State Genesis offers *UNLIMITED* number of NFTs for 1 BTC
    // How is that even possible?
    // As we establish multiplanetary civilisation, some of the accrued money will be put back into the circulation (Bitcoin recycling)
    function purchaseWithWBTC() public {
        WBTC.transferFrom(msg.sender, multisig, 10 ** 18);
        _mint(msg.sender, currentSerialNumber);
        Purchase(msg.sender, currentSerialNumber, 0, true);
        currentSerialNumber++;
    }

    // ALWAYS FREE (only the gas fee) and available to everyone. Free claim as opposed to the actual purchase.
    // BUT: if someone can afford to send a transaction on ETH, they surely can afford 0.07 ETH? (not 100% sure if `free claim` is really needed)
    // TODO: cross-check with proof of humanity (sybil attack) and store signature off-chain
    // We do not know yet, probably there will be some airdrop to all the citizens? TBD. TBC.
    event FreeClaim(address indexed addr);
    mapping(address => uint) public registrationTime;
    
    function freeClaim() public {
        require(registrationTime[msg.sender] == 0, "Address already registered");
        registrationTime[msg.sender] = block.timestamp;
        emit FreeClaim(msg.sender);
    }

    // On-chain interface for communication
    // Naturally, there will be off-chain solutions as well
    event MessagePosted(string IPFShash);
    mapping(address => string[]) public messages;

    function publishMessage(string memory IPFShash) public {
        string[] memory messagesUser = messages[msg.sender];
        if (messagesUser.length == 0) {
            messages[msg.sender] = [IPFShash];
        } else {
            messages[msg.sender].push(IPFShash);
        }

        emit MessagePosted(IPFShash);
    }

    // Need to have decidated function, see: https://ethereum.stackexchange.com/a/20838/2524
    function getMessagesLength(address addr) public view returns(uint256) {
        return messages[addr].length;
    }
}