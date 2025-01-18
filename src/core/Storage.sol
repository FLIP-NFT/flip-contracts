// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/Math.sol";

contract Storage {

    uint256 public initialPrice;
    uint256 public maxSupply;
    uint256 public creatorFeePercent;
    address public creator;
    
    uint256 public currentSupply;
    uint256[] public availableTokens;
    mapping(uint256 => uint256) public tokenIndex;

    constructor(uint256 _initialPrice, uint256 _maxSupply, uint256 _creatorFeePercent) {
        initialPrice = _initialPrice;
        maxSupply = _maxSupply;
        creatorFeePercent = _creatorFeePercent;
        creator = msg.sender;
    }

    function _setCreator(address _creator) internal {
        creator = _creator;
    }

    function getAvailableTokenByIndex(uint256 index) public view returns (uint256) {
        return availableTokens[index];
    }

    function getAvailableTokens(uint256 index) public view returns (uint256) {
        return availableTokens[index];
    }

    function getAvailableTokensPaginated(uint256 start, uint256 limit) public view returns (uint256[] memory) {
        require(start < availableTokens.length, "Start index out of bounds");
        uint256 end = Math.min(start + limit, availableTokens.length);
        uint256[] memory result = new uint256[](end - start);
        for (uint256 i = start; i < end; i++) {
            result[i - start] = availableTokens[i];
        }
        return result;
    }

    function getAvailableTokensCount() public view returns (uint256) {
        return availableTokens.length;
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

}