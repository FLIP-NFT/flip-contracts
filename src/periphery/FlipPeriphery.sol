// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "../interfaces/ITrade.sol";
import "../interfaces/IStorage.sol";
import "../interfaces/IPrice.sol";

/**
 * @title FlipPeriphery Contract
 * @author @lukema95
 * @notice Periphery contract for FLIP NFTs
 */
contract FlipPeriphery is ERC721Holder {

    /// @notice Event emitted when a mint is executed
    event Minted(address indexed flipContract, address indexed to, uint256 indexed tokenId, uint256 price);

    /// @notice Event emitted when a buy is executed
    event Bought(address indexed flipContract, address indexed buyer, uint256 indexed tokenId, uint256 price);

    /// @notice Event emitted when a sell is executed
    event Sold(address indexed flipContract, address indexed seller, uint256 indexed tokenId, uint256 price);

    /// @notice Event emitted when a bulk buy is executed
    event BulkBuyExecuted(address indexed flipContract, address indexed buyer, uint256[] tokenIds, uint256 totalPrice);

    /// @notice Event emitted when a bulk sell is executed
    event BulkSellExecuted(address indexed flipContract, address indexed seller, uint256[] tokenIds, uint256 totalPrice);

    /// @notice Event emitted when a bulk mint is executed
    event BulkMintExecuted(address indexed flipContract, address indexed buyer, uint256 quantity, uint256 totalPrice);

    /// @notice Event emitted when a bulk quick buy is executed
    event BulkQuickBuyExecuted(address indexed flipContract, address indexed buyer, uint256 quantity, uint256 totalPrice);

    /// @notice Event emitted when a quick buy is executed
    event QuickBuyExecuted(address indexed flipContract, address indexed buyer, uint256 indexed tokenId, uint256 price);

    /// @notice Mint a NFT
    /// @param _flipContractAddress The address of the flip contract
    function mint(address _flipContractAddress) external payable {
        ITrade flipContract = ITrade(_flipContractAddress);
        IPrice priceContract = IPrice(_flipContractAddress);
        uint256 price = priceContract.getBuyPriceAfterFee();
        uint256 tokenId = flipContract.mint{value: msg.value}();
        flipContract.transferFrom(address(this), msg.sender, tokenId);

        emit Minted(_flipContractAddress, msg.sender, tokenId, price);
    }

    /// @notice Buy a NFT
    /// @param _flipContractAddress The address of the flip contract
    /// @param tokenId The ID of the NFT to buy
    function buy(address _flipContractAddress, uint256 tokenId) external payable {
        IPrice priceContract = IPrice(_flipContractAddress);
        uint256 price = priceContract.getBuyPriceAfterFee();
        ITrade flipContract = ITrade(_flipContractAddress);
        flipContract.buy{value: msg.value}(tokenId);
        flipContract.transferFrom(address(this), msg.sender, tokenId);

        emit Bought(_flipContractAddress, msg.sender, tokenId, price);
    }

    /// @notice Sell a NFT
    /// @param _flipContractAddress The address of the flip contract
    /// @param tokenId The ID of the NFT to sell
    function sell(address _flipContractAddress, uint256 tokenId) external {
        ITrade flipContract = ITrade(_flipContractAddress);
        IPrice priceContract = IPrice(_flipContractAddress);
        uint256 price = priceContract.getSellPriceAfterFee();
        flipContract.transferFrom(msg.sender, address(this), tokenId);
        flipContract.sell(tokenId);

        (bool success, ) = msg.sender.call{value: price}("");
        require(success, "Transfer failed");

        emit Sold(_flipContractAddress, msg.sender, tokenId, price);
    }

    /// @notice Quick buy a NFT
    /// @param _flipContractAddress The address of the flip contract
    function quickBuy(address _flipContractAddress) public payable {
        ITrade flipContract = ITrade(_flipContractAddress);
        IStorage storageContract = IStorage(_flipContractAddress);
        IPrice priceContract = IPrice(_flipContractAddress);
        require(storageContract.getAvailableTokensCount() > 0, "No tokens available for quick buy");
        uint256 tokenId = storageContract.getAvailableTokenByIndex(storageContract.getAvailableTokensCount() - 1);
        uint256 price = priceContract.getBuyPriceAfterFee();
        flipContract.buy{value: price}(tokenId);
        flipContract.transferFrom(address(this), msg.sender, tokenId);
        
        emit QuickBuyExecuted(_flipContractAddress, msg.sender, tokenId, price);
    }

    /// @notice Buy multiple NFTs
    /// @param _flipContractAddress The address of the flip contract
    /// @param tokenIds The IDs of the NFTs to buy
    function bulkBuy(address _flipContractAddress, uint256[] calldata tokenIds) external payable {
        ITrade flipContract = ITrade(_flipContractAddress);
        IPrice priceContract = IPrice(_flipContractAddress);
        uint256 totalPrice = 0;
        for (uint256 i = 0; i < tokenIds.length; i++) {
            uint256 price = priceContract.getBuyPriceAfterFee();
            totalPrice += price;
            flipContract.buy{value: price}(tokenIds[i]);
            flipContract.transferFrom(address(this), msg.sender, tokenIds[i]);
        }
        require(msg.value >= totalPrice, "Insufficient payment");
        
        emit BulkBuyExecuted(_flipContractAddress, msg.sender, tokenIds, totalPrice);

        // Refund excess ETH
        uint256 excess = msg.value - totalPrice;
        if (excess > 0) {
            (bool success, ) = msg.sender.call{value: excess}("");
            require(success, "Refund failed");
        }
    }

    /// @notice Buy multiple NFTs in a single transaction
    /// @param _flipContractAddress The address of the flip contract
    /// @param quantity The quantity of NFTs to buy
    function bulkQuickBuy(address _flipContractAddress, uint256 quantity) external payable {
        ITrade flipContract = ITrade(_flipContractAddress);
        IStorage storageContract = IStorage(_flipContractAddress);
        IPrice priceContract = IPrice(_flipContractAddress);
        uint256 totalPrice = 0;
        uint256 availableTokensCount = storageContract.getAvailableTokensCount();
        require(availableTokensCount > quantity, "Not enough tokens available for quick buy");
        for (uint256 i = 0; i < quantity; i++) {
            uint256 tokenId = storageContract.getAvailableTokenByIndex(availableTokensCount - 1);
            uint256 price = priceContract.getBuyPriceAfterFee();
            totalPrice += price;
            flipContract.buy{value: price}(tokenId);
            flipContract.transferFrom(address(this), msg.sender, tokenId);
            availableTokensCount--;
        }
        require(msg.value >= totalPrice, "Insufficient payment");
        
        emit BulkQuickBuyExecuted(_flipContractAddress, msg.sender, quantity, totalPrice);

        // Refund excess ETH
        uint256 excess = msg.value - totalPrice;
        if (excess > 0) {
            (bool success, ) = msg.sender.call{value: excess}("");
            require(success, "Refund failed");
        }
    }

    /// @notice Sell multiple NFTs
    /// @param _flipContractAddress The address of the flip contract
    /// @param tokenIds The IDs of the NFTs to sell
    function bulkSell(address _flipContractAddress, uint256[] calldata tokenIds) external {
        ITrade flipContract = ITrade(_flipContractAddress);
        IPrice priceContract = IPrice(_flipContractAddress);
        uint256 totalPrice = 0;
        for (uint256 i = 0; i < tokenIds.length; i++) {
            uint256 tokenId = tokenIds[i];
            require(flipContract.ownerOf(tokenId) == msg.sender, "Not token owner");
            uint256 price = priceContract.getSellPriceAfterFee();
            totalPrice += price;

            flipContract.transferFrom(msg.sender, address(this), tokenId);
            flipContract.sell(tokenId);
        }
        
        emit BulkSellExecuted(_flipContractAddress, msg.sender, tokenIds, totalPrice);

        (bool success, ) = msg.sender.call{value: totalPrice}("");
        require(success, "Transfer failed");
    }

    /// @notice Mint multiple NFTs
    /// @param _flipContractAddress The address of the flip contract
    /// @param quantity The quantity of NFTs to mint
    function bulkMint(address _flipContractAddress, uint256 quantity) external payable {
        ITrade flipContract = ITrade(_flipContractAddress);
        IPrice priceContract = IPrice(_flipContractAddress);
        uint256 totalPrice = 0;
        for (uint256 i = 0; i < quantity; i++) {
            uint256 price = priceContract.getBuyPriceAfterFee();
            totalPrice += price;
            uint256 tokenId = flipContract.mint{value: price}();
            flipContract.transferFrom(address(this), msg.sender, tokenId);
        }
        require(msg.value >= totalPrice, "Insufficient payment");
        
        emit BulkMintExecuted(_flipContractAddress, msg.sender, quantity, totalPrice);

        // Refund excess ETH
        uint256 excess = msg.value - totalPrice;
        if (excess > 0) {
            (bool success, ) = msg.sender.call{value: excess}("");
            require(success, "Refund failed");
        }
    }

    receive() external payable {}
}