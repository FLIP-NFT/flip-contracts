// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "@openzeppelin/contracts/utils/math/SignedMath.sol";

contract Flip is ERC721, ERC721Holder, Ownable {
    using Math for uint256;

    uint256 public constant MAX_SUPPLY = 10000;
    uint256 public totalSupply;
    uint256 public initialPrice; 
    uint256 public accumulatedBuyCount;
    uint256 public accumulatedSellCount;
    uint256[] public availableTokens;
    mapping(uint256 => uint256) public tokenIndex;

    constructor(
        uint256 _initialPrice
    ) ERC721("FlipNFT", "FLIP") Ownable(msg.sender) {
        initialPrice = _initialPrice;
        totalSupply = 0;
    }

    function mint() public payable {
        require(msg.value >= initialPrice, "Insufficient payment");
        require(totalSupply < MAX_SUPPLY, "Max supply reached");

        uint256 tokenId = totalSupply + 1;
        _safeMint(msg.sender, tokenId);
        totalSupply = totalSupply + 1;
    }

    function getMintPrice() public view returns (uint256) {
        return initialPrice + initialPrice / totalSupply ;
    }

    function buy(uint256 tokenId) public payable {
        require(ownerOf(tokenId) == address(this), "Token is not available for sale");
        uint256 price = getBuyPrice(); 
        require(msg.value >= price, "Insufficient payment");

        _transfer(address(this), msg.sender, tokenId);

        // Remove token from availableTokens
        removeAvailableToken(tokenId);

        accumulatedBuyCount = accumulatedBuyCount + 1;  
    }

    function quickBuy() public payable {
        require(availableTokens.length > 0, "No tokens available for quick buy");
        uint256 price = getBuyPrice(); 
        require(msg.value >= price, "Insufficient payment");

        uint256 tokenId = availableTokens[availableTokens.length - 1];
        _transfer(address(this), msg.sender, tokenId);

        // Remove token from availableTokens
        removeAvailableToken(tokenId);

        accumulatedBuyCount = accumulatedBuyCount + 1;
    }

    function sell(uint256 tokenId) public {
        require(ownerOf(tokenId) == _msgSender(), "Caller is not owner");
        uint256 price = getSellPrice();

        _transfer(_msgSender(), address(this), tokenId);
        (bool success, ) = _msgSender().call{value: price}("");
        require(success, "Transfer failed");

        // Add token to availableTokens
        availableTokens.push(tokenId);

        accumulatedSellCount = accumulatedSellCount + 1;
    }
      
    function calculatePrice(uint256 buyCount, uint256 sellCount, bool isBuy) public view returns (uint256) {
        if (totalSupply < MAX_SUPPLY) {
            return initialPrice;
        }

        uint256 order = sellCount - buyCount;    
        uint256 cnt = sellCount + buyCount; 

        uint256 price;
        if (isBuy) {
            price = initialPrice * Math.sqrt(Math.sqrt(2 * (cnt + 1))) / Math.sqrt(Math.sqrt(order + 1));
        } else {
            price = initialPrice * Math.sqrt(Math.sqrt(cnt + 1)) / Math.sqrt(Math.sqrt(order + 1));
        }

        return price;
    }

    function curve(uint256 x) public pure returns (uint256) {
        return x * x;
    }

    function getBuyPrice() public view returns (uint256) {
        return calculatePrice(accumulatedBuyCount, accumulatedSellCount, true);
    }

    function getSellPrice() public view returns (uint256) {
        return calculatePrice(accumulatedBuyCount, accumulatedSellCount, false);
    }

    function removeAvailableToken(uint256 tokenId) internal {
        uint256 index = tokenIndex[tokenId];
        uint256 lastIndex = availableTokens.length - 1;
        uint256 lastToken = availableTokens[lastIndex];

        availableTokens[index] = lastToken;
        tokenIndex[lastToken] = index;

        availableTokens.pop();
    }
}