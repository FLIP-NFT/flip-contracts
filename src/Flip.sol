// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "@openzeppelin/contracts/utils/math/SignedMath.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract Flip is ERC721, ERC721Holder, Ownable {
    using Math for uint256;

    event TokenMinted(address indexed to, uint256 indexed tokenId, uint256 price, uint256 creatorFee);
    event TokenBought(address indexed buyer, uint256 indexed tokenId, uint256 price, uint256 creatorFee);
    event TokenSold(address indexed seller, uint256 indexed tokenId, uint256 price, uint256 creatorFee);
    event QuickBuyExecuted(address indexed buyer, uint256 indexed tokenId, uint256 price);

    bytes constant PI_DIGITS = "14159265358979323846264338327950288419716939937510582097494459230781640628620899862803482534211706798";
    uint256 public constant MAX_SUPPLY = 10000;
    uint256 public constant INITIAL_PRICE = 0.001 ether; 
    uint256 public constant CREATOR_FEE_PERCENT = 0.05 ether; // 5%
    address public creator;

    uint256 public totalSupply;
    uint256 public currentSupply;
    uint256[] public availableTokens;
    mapping(uint256 => uint256) public tokenIndex;
    mapping(uint256 => uint256) public tokenSeed;

    constructor() ERC721("FlipNFT", "FLIP") Ownable(msg.sender) {
        creator = msg.sender;
        totalSupply = 0;
    }

    modifier onlyTokenOwner(uint256 tokenId) {
        require(ownerOf(tokenId) == _msgSender(), "Caller is not owner");
        _;
    }

    modifier onlyTokenOnSale(uint256 tokenId) {
        require(ownerOf(tokenId) == address(this), "Token is not available for sale");
        _;
    }

    function mint() public payable {
        require(totalSupply <= MAX_SUPPLY, "Max supply reached");
        
        uint256 price = getBuyPrice();
        uint256 creatorFee = price * CREATOR_FEE_PERCENT / 1 ether;
        require(msg.value >= price + creatorFee, "Insufficient payment");

        uint256 tokenId = ++totalSupply;
        
        _safeMint(msg.sender, tokenId);
        ++currentSupply;

        emit TokenMinted(msg.sender, tokenId, price, creatorFee);
        tokenSeed[tokenId] = block.timestamp;

        (bool success, ) = creator.call{value: creatorFee}("");
        require(success, "Transfer failed");

        _refundExcess(price + creatorFee);
    }

    function quickBuy() public payable {
        require(availableTokens.length > 0, "No tokens available for quick buy");
        uint256 tokenId = availableTokens[availableTokens.length - 1];
        
        buy(tokenId);
        
        emit QuickBuyExecuted(msg.sender, tokenId, getBuyPrice());
    }

    function buy(uint256 tokenId) public payable onlyTokenOnSale(tokenId) {
        uint256 price = getBuyPrice(); 
        uint256 creatorFee = price * CREATOR_FEE_PERCENT / 1 ether;
        require(msg.value >= price + creatorFee, "Insufficient payment");

        _transfer(address(this), msg.sender, tokenId);

        removeAvailableToken(tokenId);
        ++currentSupply;

        emit TokenBought(msg.sender, tokenId, price, creatorFee);

        (bool success, ) = creator.call{value: creatorFee}("");
        require(success, "Transfer failed");

        _refundExcess(price + creatorFee);
    }

    function sell(uint256 tokenId) public onlyTokenOwner(tokenId) {
        uint256 price = getSellPrice();
        uint256 creatorFee = price * CREATOR_FEE_PERCENT / 1 ether;

        _transfer(_msgSender(), address(this), tokenId);
        addAvailableToken(tokenId);
        --currentSupply;

        emit TokenSold(_msgSender(), tokenId, price, creatorFee);

        (bool sentToSeller, ) = _msgSender().call{value: price - creatorFee}("");
        require(sentToSeller, "Transfer to seller failed");

        (bool sentToCreator, ) = creator.call{value: creatorFee}("");
        require(sentToCreator, "Transfer to creator failed");
    }

    function getAvailableTokens() public view returns (uint256[] memory) {
        return availableTokens;
    }

    function isOnSale(uint256 tokenId) public view returns (bool) {
        return ownerOf(tokenId) == address(this);
    }

    function getBuyPriceAfterFee() public view returns (uint256) {
        uint256 price = getBuyPrice();
        uint256 fee = price * CREATOR_FEE_PERCENT / 1 ether;
        return price + fee;
    }

    function getSellPriceAfterFee() public view returns (uint256) {
        uint256 price = getSellPrice();
        uint256 fee = price * CREATOR_FEE_PERCENT / 1 ether;
        return price - fee;
    }

    function getBuyPrice() public view returns (uint256) {
        return calculatePrice(currentSupply);
    }

    function getSellPrice() public view returns (uint256) {
        return calculatePrice(currentSupply > 0 ? currentSupply - 1 : 0);
    }

    function calculatePrice(uint256 supply) public pure returns (uint256) {
        if (supply == 0) return INITIAL_PRICE;

        uint256 price = INITIAL_PRICE + INITIAL_PRICE * 2 * Math.sqrt(100 * supply / MAX_SUPPLY) * Math.sqrt(10000 * supply * supply / MAX_SUPPLY / MAX_SUPPLY);
        return price;
    }

    function tokenURI(uint256 tokenID) public view virtual override returns (string memory) {
        string memory piValue = getPi(tokenSeed[tokenID] + tokenID);
        string memory svg = string(abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>',
            '<rect width="100%" height="100%" fill="black" />',
            '<text x="10" y="20" class="base">TokenID: ', Strings.toString(tokenID), '</text>',
            '<text x="10" y="40" class="base">Pi = ', piValue, '</text>',
            '</svg>'
        ));

        string memory json = Base64.encode(
            bytes(string(abi.encodePacked(
                '{"description": "FlipNFT is the first Bonding Curve NFT.", "image": "data:image/svg+xml;base64,',
                Base64.encode(bytes(svg)),
                '"}'
            )))
        );

        return string(abi.encodePacked("data:application/json;base64,", json));
    }

    function getPi(uint256 n) public pure returns (string memory) {
        n = n % 100;
        
        bytes memory result = new bytes(n + 1);
        
        result[0] = "3";
        result[1] = ".";
        
        uint256 digitsToAdd = n > 1 ? n - 1 : 0;
        for (uint256 i = 0; i < digitsToAdd && i < PI_DIGITS.length; i++) {
            result[i + 2] = PI_DIGITS[i];
        }
    
        return string(result);
    }

    function removeAvailableToken(uint256 tokenId) internal {
        uint256 index = tokenIndex[tokenId];
        uint256 lastIndex = availableTokens.length - 1;
        uint256 lastToken = availableTokens[lastIndex];

        availableTokens[index] = lastToken;
        tokenIndex[lastToken] = index;

        availableTokens.pop();
        // delete tokenIndex[tokenId];
    }

    function addAvailableToken(uint256 tokenId) internal {
        availableTokens.push(tokenId);
        tokenIndex[tokenId] = availableTokens.length - 1;
    }

    function _refundExcess(uint256 price) internal {
        uint256 refundAmount = msg.value - price;
        if (refundAmount > 0) {
            (bool success, ) = _msgSender().call{value: refundAmount}("");
            require(success, "Refund failed");
        }
    }

    receive() external payable {}
}