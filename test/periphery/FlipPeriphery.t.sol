// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {FlipPeriphery} from "../../src/periphery/FlipPeriphery.sol";
import {Trade} from "../../src/core/Trade.sol";
import {FeeVault} from "../../src/core/FeeVault.sol";

contract FlipPeripheryTest is Test {
    receive() external payable {}
    
    FlipPeriphery public flipPeriphery;
    Trade public trade;
    FeeVault public feeVault;
    address alice = address(0x1);

    function setUp() public {
        feeVault = new FeeVault();
        trade = new Trade(address(feeVault), "Flip", "FLIP", 0.001 ether, 10000, 0.05 ether);
        flipPeriphery = new FlipPeriphery();
    }

    function test_mint() public {
        vm.deal(alice, 100 ether);
        vm.prank(alice);
        flipPeriphery.mint{value: 1 ether}(address(trade));
        assertEq(trade.balanceOf(alice), 1);
    }

    function test_sell_and_buy() public {
        vm.deal(alice, 100 ether);
        vm.prank(alice);
        flipPeriphery.mint{value: 1 ether}(address(trade));
        assertEq(trade.balanceOf(alice), 1);

        vm.prank(alice);
        trade.setApprovalForAll(address(flipPeriphery), true);
        vm.prank(alice);
        flipPeriphery.sell(address(trade), 1);
        assertEq(trade.balanceOf(alice), 0);

        vm.prank(alice);
        flipPeriphery.buy{value: 1 ether}(address(trade), 1);
        assertEq(trade.balanceOf(alice), 1);
    }
    
    function test_bulkMint() public {
        vm.deal(alice, 100 ether);
        vm.prank(alice);
        flipPeriphery.bulkMint{value: 1 ether}(address(trade), 10);
        assertEq(trade.balanceOf(alice), 10);
    }

    function test_bulkBuy_and_bulkSell() public {
        vm.deal(alice, 100 ether);
        vm.prank(alice);
        flipPeriphery.bulkMint{value: 1 ether}(address(trade), 10);
        assertEq(trade.balanceOf(alice), 10);
        
        uint256[] memory tokenIds = new uint256[](10);
        for (uint256 i = 1; i <= 10; i++) {
            tokenIds[i-1] = i;
            assertEq(trade.ownerOf(i), alice);
        }

        // Sell all tokens by bulkSell
        vm.prank(alice);
        trade.setApprovalForAll(address(flipPeriphery), true);
        vm.prank(alice);
        flipPeriphery.bulkSell(address(trade), tokenIds);
        assertEq(trade.balanceOf(alice), 0);

        // Buy 5 tokens by bulkQuickBuy
        vm.prank(alice);
        flipPeriphery.bulkQuickBuy{value: 1 ether}(address(trade), 5);
        assertEq(trade.balanceOf(alice), 5);

        // Get available tokens
        uint256[] memory avalibleTokens = trade.getAllAvailableTokens();
        assertEq(avalibleTokens.length, 5);

        // Buy all tokens by bulkBuy
        vm.prank(alice);
        flipPeriphery.bulkBuy{value: 1 ether}(address(trade), avalibleTokens);
        assertEq(trade.balanceOf(alice), 10);
    }

}
