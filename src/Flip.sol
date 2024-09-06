// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "@openzeppelin/contracts/utils/math/SignedMath.sol";

contract Flip is ERC721, ERC721Holder, Ownable {
    using Math for uint256;

    event TokenMinted(address indexed to, uint256 indexed tokenId, uint256 price);
    event TokenBought(address indexed buyer, uint256 indexed tokenId, uint256 price);
    event TokenSold(address indexed seller, uint256 indexed tokenId, uint256 price);
    event QuickBuyExecuted(address indexed buyer, uint256 indexed tokenId, uint256 price);

    uint256 public constant MAX_SUPPLY = 10000;
    uint256 public totalSupply;
    uint256 public currentSupply;
    uint256 public initialPrice; 
    uint256[] public availableTokens;
    mapping(uint256 => uint256) public tokenIndex;

    constructor(
        uint256 _initialPrice
    ) ERC721("FlipNFT", "FLIP") Ownable(msg.sender) {
        initialPrice = _initialPrice;
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
        require(msg.value >= price, "Insufficient payment");

        uint256 tokenId = ++totalSupply;
        
        _safeMint(msg.sender, tokenId);
        ++currentSupply;

        emit TokenMinted(msg.sender, tokenId, price);

        _refundExcess(price);
    }

    function quickBuy() public payable {
        require(availableTokens.length > 0, "No tokens available for quick buy");
        uint256 tokenId = availableTokens[availableTokens.length - 1];
        
        buy(tokenId);
        
        emit QuickBuyExecuted(msg.sender, tokenId, getBuyPrice());
    }

    function buy(uint256 tokenId) public payable onlyTokenOnSale(tokenId) {
        uint256 price = getBuyPrice(); 
        require(msg.value >= price, "Insufficient payment");

        _transfer(address(this), msg.sender, tokenId);

        removeAvailableToken(tokenId);
        ++currentSupply;

        emit TokenBought(msg.sender, tokenId, price);

        _refundExcess(price);
    }

    function sell(uint256 tokenId) public onlyTokenOwner(tokenId) {
        uint256 price = getSellPrice();

        _transfer(_msgSender(), address(this), tokenId);
        addAvailableToken(tokenId);
        --currentSupply;

        emit TokenSold(_msgSender(), tokenId, price);

        (bool success, ) = _msgSender().call{value: price}("");
        require(success, "Transfer failed");
    }

    function getBuyPrice() public view returns (uint256) {
        return calculatePrice(currentSupply);
    }

    function getSellPrice() public view returns (uint256) {
        return calculatePrice(currentSupply - 1);
    }

    function calculatePrice(uint256 supply) public view returns (uint256) {
        return _curve(supply + 1 * 2) - _curve(supply);
    }

    function _curve(uint256 x) internal view returns (uint256) {
        return x < initialPrice ? initialPrice : (x - initialPrice) * (x - initialPrice);
    }

    function removeAvailableToken(uint256 tokenId) internal {
        uint256 index = tokenIndex[tokenId];
        uint256 lastIndex = availableTokens.length - 1;
        uint256 lastToken = availableTokens[lastIndex];

        availableTokens[index] = lastToken;
        tokenIndex[lastToken] = index;

        availableTokens.pop();
        delete tokenIndex[tokenId];
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
}