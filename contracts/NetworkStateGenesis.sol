// SPDX-License-Identifier: MIT
pragma solidity 0.8.3;
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NetworkStateGenesis is ERC721, Ownable {
    string public GENESIS; // Preserving consciousness of the moment
    string public _tokenURI;
    uint256 public currentPrice = 7 * (10 ** 15); // Starting price is 0.007 ETH (1/10th of ETH mainnet price)
   	uint256 public currentSerialNumber = 128;
    uint256 public cutoffTimestamp;  // Initially all have the same price. Later on (1625443200 ---> 2021-07-05T00:00:00.000Z) the 0.1% increase kicks in
  	uint256 public multiplier = 1005; 
  	uint256 public divisor = 1000; // Doing math in ETH. Multiply by 1005. Divide by 1000. Effectively 0.5% increase with each purchase (higher than 0.1% that was present in V1)
  	event Purchase(address addr, uint256 currentSerialNumber, uint256 price);

    address payable public multisig; // Ensure you are comfortable with m-of-n signatories on Gnosis Safe (don't trust, verify)
    address public minter;

    constructor(string memory name, string memory symbol, address _minter) ERC721(name, symbol) {
        minter = _minter;
    }

    // 1. Deploy 2. Include the smart contract address in the PDF. 3. Upload PDF to IPFS 4. Save IPFS hash in this method.
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

    function mint(address addr, uint serialNumber) payable public {
        require(msg.sender == minter, "Only minter can mint");
        _mint(addr, serialNumber);
    }
}