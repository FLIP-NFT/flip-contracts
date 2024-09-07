// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "@openzeppelin/contracts/utils/math/SignedMath.sol";

contract Flip is ERC721, ERC721Holder, Ownable {
    using Math for uint256;

    event TokenMinted(address indexed to, uint256 indexed tokenId, uint256 price, uint256 creatorFee);
    event TokenBought(address indexed buyer, uint256 indexed tokenId, uint256 price, uint256 creatorFee);
    event TokenSold(address indexed seller, uint256 indexed tokenId, uint256 price, uint256 creatorFee);
    event QuickBuyExecuted(address indexed buyer, uint256 indexed tokenId, uint256 price);

    uint256 public constant MAX_SUPPLY = 10000;
    uint256 public constant INITIAL_PRICE = 0.001 ether; 
    uint256 public constant CREATOR_FEE_PERCENT = 0.05 ether; // 5%
    address public creator;

    uint256 public totalSupply;
    uint256 public currentSupply;
    uint256[] public availableTokens;
    mapping(uint256 => uint256) public tokenIndex;

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