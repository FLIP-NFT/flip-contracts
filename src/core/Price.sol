// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/Math.sol";
import "./BaseNFT.sol";

/**
 * @title Price Contract
 * @author @lukema95
 * @notice Price contract to calculate the price of NFTs, implements BaseNFT
 * @dev This contract is abstract and should be inherited by the FLIP contract
 */
abstract contract Price is BaseNFT {
    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _initialPrice,
        uint256 _maxSupply,
        uint256 _creatorFeePercent
    ) BaseNFT(_name, _symbol, _initialPrice, _maxSupply, _creatorFeePercent) {}
    
    function getBuyPriceAfterFee() public view returns (uint256) {
        uint256 price = getBuyPrice();
        uint256 fee = price * creatorFeePercent / 1 ether;
        return price + fee;
    }

    function getSellPriceAfterFee() public view returns (uint256) {
        uint256 price = getSellPrice();
        uint256 fee = price * creatorFeePercent / 1 ether;
        return price - fee;
    }

    function getBuyPrice() public view returns (uint256) {
        return calculatePrice(currentSupply);
    }

    function getSellPrice() public view returns (uint256) {
        return calculatePrice(currentSupply > 0 ? currentSupply - 1 : 0);
    }

    function calculatePrice(uint256 supply) public view virtual returns (uint256) {
        if (supply == 0) return initialPrice;

        uint256 price = initialPrice + initialPrice * 2 * Math.sqrt(100 * supply / maxSupply) * Math.sqrt(10000 * supply * supply / maxSupply / maxSupply);
        return price;
    }

}