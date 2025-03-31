// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "./IStorage.sol";

/**
 * @title IBaseNFT Interface
 * @author @lukema95
 * @notice Interface for BaseNFT contract
 */
interface IBaseNFT is IERC721, IStorage {
    /**
     * @notice Get the contract URI
     * @return The contract URI
     */
    function contractURI() external view returns (string memory);
}
