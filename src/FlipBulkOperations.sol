// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "./Flip.sol";

contract FlipBulkOperations is ERC721Holder {
    Flip public immutable flipContract;

    event BulkBuyExecuted(address indexed buyer, uint256[] tokenIds, uint256 totalPrice);
    event BulkSellExecuted(address indexed seller, uint256[] tokenIds, uint256 totalPrice);
    event BulkMintExecuted(address indexed buyer, uint256 quantity, uint256 totalPrice);
    event BulkQuickBuyExecuted(address indexed buyer, uint256 quantity, uint256 totalPrice);

    constructor(address _flipContractAddress) {
        flipContract = Flip(payable(_flipContractAddress));
    }

    function bulkBuy(uint256[] calldata tokenIds) external payable {
        uint256 totalPrice = 0;
        for (uint256 i = 0; i < tokenIds.length; i++) {
            uint256 price = flipContract.getBuyPrice();
            totalPrice += price;
            flipContract.buy{value: price}(tokenIds[i]);
        }
        require(msg.value >= totalPrice, "Insufficient payment");
        
        emit BulkBuyExecuted(msg.sender, tokenIds, totalPrice);

        // Refund excess ETH
        uint256 excess = msg.value - totalPrice;
        if (excess > 0) {
            (bool success, ) = msg.sender.call{value: excess}("");
            require(success, "Refund failed");
        }
    }

    function bulkQuickBuy(uint256 quantity) external payable {
        uint256 totalPrice = 0;
        for (uint256 i = 0; i < quantity; i++) {
            uint256 price = flipContract.getBuyPrice();
            totalPrice += price;
            flipContract.quickBuy{value: price}();
        }
        require(msg.value >= totalPrice, "Insufficient payment");
        
        emit BulkQuickBuyExecuted(msg.sender, quantity, totalPrice);

        // Refund excess ETH
        uint256 excess = msg.value - totalPrice;
        if (excess > 0) {
            (bool success, ) = msg.sender.call{value: excess}("");
            require(success, "Refund failed");
        }
    }

    function bulkSell(uint256[] calldata tokenIds) external {
        uint256 totalPrice = 0;
        for (uint256 i = 0; i < tokenIds.length; i++) {
            require(flipContract.ownerOf(tokenIds[i]) == msg.sender, "Not token owner");
            flipContract.transferFrom(msg.sender, address(this), tokenIds[i]);
            flipContract.sell(tokenIds[i]);
            uint256 price = flipContract.getSellPrice();
            totalPrice += price;
        }
        
        emit BulkSellExecuted(msg.sender, tokenIds, totalPrice);

        (bool success, ) = msg.sender.call{value: totalPrice}("");
        require(success, "Transfer failed");
    }

    function bulkMint(uint256 quantity) external payable {
        uint256 totalPrice = 0;
        for (uint256 i = 0; i < quantity; i++) {
            uint256 price = flipContract.getBuyPrice();
            totalPrice += price;
            flipContract.mint{value: price}();
        }
        require(msg.value >= totalPrice, "Insufficient payment");
        
        emit BulkMintExecuted(msg.sender, quantity, totalPrice);

        // Refund excess ETH
        uint256 excess = msg.value - totalPrice;
        if (excess > 0) {
            (bool success, ) = msg.sender.call{value: excess}("");
            require(success, "Refund failed");
        }
    }

    // Allow contract to receive ETH
    receive() external payable {}
}