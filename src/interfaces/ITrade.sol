// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "./IStorage.sol";
import "./IPrice.sol";

/**
 * @title ITrade Interface
 * @author @lukema95
 * @notice Interface for the Trade contract, every FLIP contract should implement this interface
 */
interface ITrade is IERC721 {
    /// @notice Event emitted when a token is minted
    event TokenMinted(address indexed to, uint256 indexed tokenId, uint256 price, uint256 creatorFee);
    
    /// @notice Event emitted when a token is bought
    event TokenBought(address indexed buyer, uint256 indexed tokenId, uint256 price, uint256 creatorFee);
    
    /// @notice Event emitted when a token is sold
    event TokenSold(address indexed seller, uint256 indexed tokenId, uint256 price, uint256 creatorFee);

    /// @notice Function to mint a token
    /// @return The token ID
    function mint() external payable returns (uint256);

    /// @notice Function to buy a token
    function buy(uint256 tokenId) external payable;

    /// @notice Function to sell a token
    function sell(uint256 tokenId) external;
}
