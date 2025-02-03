// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title IStorage Interface
 * @author @lukema95
 * @notice Interface for Storage contract
 */
interface IStorage {
    /// @notice Get all available tokens
    /// @return The available tokens
    function getAllAvailableTokens() external view returns (uint256[] memory);

    /// @notice Get the available token by index
    /// @param index The index of the token
    /// @return The token ID
    function getAvailableTokenByIndex(uint256 index) external view returns (uint256);

    /// @notice Get the available tokens paginated
    /// @param start The start index
    /// @param limit The limit of tokens to return
    /// @return The token IDs
    function getAvailableTokensPaginated(uint256 start, uint256 limit) external view returns (uint256[] memory);

    /// @notice Get the available tokens count
    /// @return The number of available tokens
    function getAvailableTokensCount() external view returns (uint256);
}
