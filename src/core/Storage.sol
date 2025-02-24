// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/Math.sol";
import "../interfaces/IStorage.sol";

/**
 * @title Storage Contract
 * @author @lukema95
 * @notice Storage contract to store the FLIP data
 */
contract Storage is IStorage {

    uint256 public initialPrice;
    uint256 public maxSupply;
    uint256 public creatorFeePercent;
    address public creator;
    
    uint256 public currentSupply;
    uint256[] public availableTokens;
    mapping(uint256 => uint256) public tokenIndex;

    string public baseURI;

    modifier onlyCreator() {
        require(msg.sender == creator, "Only creator can call this function");
        _;
    }

    constructor(uint256 _initialPrice, uint256 _maxSupply, uint256 _creatorFeePercent) {
        initialPrice = _initialPrice;
        maxSupply = _maxSupply;
        creatorFeePercent = _creatorFeePercent;
        creator = msg.sender;
    }

    function setCreator(address _creator) public onlyCreator {
        creator = _creator;
    }

    function setBaseURI(string memory _baseURI) public onlyCreator {
        baseURI = _baseURI;
    }

    /// @notice Get all available tokens
    /// @return The available tokens
    function getAllAvailableTokens() public view returns (uint256[] memory) {
        return availableTokens;
    }

    /// @notice Get the available token by index
    /// @param index The index of the token
    /// @return The token ID
    function getAvailableTokenByIndex(uint256 index) public view returns (uint256) {
        return availableTokens[index];
    }

    /// @notice Get the available tokens paginated
    /// @param start The start index
    /// @param limit The limit of tokens to return
    /// @return The token IDs
    function getAvailableTokensPaginated(uint256 start, uint256 limit) public view returns (uint256[] memory) {
        require(start < availableTokens.length, "Start index out of bounds");
        uint256 end = Math.min(start + limit, availableTokens.length);
        uint256[] memory result = new uint256[](end - start);
        for (uint256 i = start; i < end; i++) {
            result[i - start] = availableTokens[i];
        }
        return result;
    }

    /// @notice Get the available tokens count
    /// @return The number of available tokens
    function getAvailableTokensCount() public view returns (uint256) {
        return availableTokens.length;
    }

    /// @notice Remove a token from the available tokens
    /// @param tokenId The ID of the token to remove
    function removeAvailableToken(uint256 tokenId) internal {
        uint256 index = tokenIndex[tokenId];
        uint256 lastIndex = availableTokens.length - 1;
        uint256 lastToken = availableTokens[lastIndex];

        availableTokens[index] = lastToken;
        tokenIndex[lastToken] = index;

        availableTokens.pop();
        delete tokenIndex[tokenId];
    }

    /// @notice Add a token to the available tokens
    /// @param tokenId The ID of the token to add
    function addAvailableToken(uint256 tokenId) internal {
        availableTokens.push(tokenId);
        tokenIndex[tokenId] = availableTokens.length - 1;
    }

}