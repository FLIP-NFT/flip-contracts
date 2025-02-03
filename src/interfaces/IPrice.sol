// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title IPrice Interface
 * @author @lukema95
 * @notice Interface for Price contract
 */
interface IPrice {
    /**
     * @notice Get the buy price including creator fee
     * @return The total price including fee
     */
    function getBuyPriceAfterFee() external view returns (uint256);

    /**
     * @notice Get the sell price after deducting creator fee
     * @return The final price after fee deduction
     */
    function getSellPriceAfterFee() external view returns (uint256);

    /**
     * @notice Get the current buy price without fee
     * @return The base buy price
     */
    function getBuyPrice() external view returns (uint256);

    /**
     * @notice Get the current sell price without fee
     * @return The base sell price
     */
    function getSellPrice() external view returns (uint256);

    /**
     * @notice Calculate the price based on current supply
     * @param supply The supply amount to calculate price for
     * @return The calculated price
     */
    function calculatePrice(uint256 supply) external view returns (uint256);
}
