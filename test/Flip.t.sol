// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Flip} from "../src/Flip.sol";

contract FlipTest is Test {
    Flip public flip;

    address alice = address(0x1);
    address bob = address(0x2);
    address carol = address(0x3);

    function setUp() public {
        flip = new Flip(0.01 ether);
    }

    function test_mint() public {
        vm.deal(alice, 100 ether);
        for (uint256 i = 0; i < 10000; i++) {
            vm.prank(alice);
            flip.mint{value: 0.01 ether}();
        }
        assertEq(flip.totalSupply(), 10000);
    }

    function test_deal() public {
        vm.deal(alice, 100 ether);
        // mint all
        for (uint256 i = 0; i < 10000; i++) {
            vm.prank(alice);
            flip.mint{value: 0.01 ether}();
        }

        uint256 contractBalance = address(flip).balance;
        console.log("contractBalance after mint", contractBalance);

        // sell 1000
        for (uint256 i = 1; i <= 2000; i++) {
            vm.prank(alice);
            flip.sell(i);
            if (i % 100 == 0 || i == 1) {
                console.log("i: ", i);
                uint256 sellPrice = flip.getSellPrice();
                console.log("sellPrice: ", sellPrice);
            }
        }
        contractBalance = address(flip).balance;
        console.log("contractBalance after sell", contractBalance);

        // buy 200
        vm.deal(bob, 100 ether);
        for (uint256 i = 1; i <= 2000; i++) {
            uint256 buyPrice = flip.getBuyPrice();
            vm.prank(bob);
            flip.buy{value: buyPrice}(i);
            if (i % 100 == 0 || i == 1) {
                console.log("i: ", i);
                console.log("buyPrice: ", buyPrice);
            }
        }
        contractBalance = address(flip).balance;
        console.log("contractBalance after buy", contractBalance);

        for (uint256 i = 1; i <= 1000; i++) {
            vm.prank(bob);
            flip.sell(i);
            if (i % 100 == 0 || i == 1) {
                console.log("i: ", i);
                uint256 sellPrice = flip.getSellPrice();
                console.log("sellPrice: ", sellPrice);
            }
        }
    }

    function test_calculatePrice() public {
        // for (uint256 i = 0; i < 200000; i++) {
        //     if (i % 1000 == 0) {
        //         uint256 lastPrice = flip.calculatePrice(i, i+1, true);
        //         console.log("i: ", i);
        //         console.log("price: ", lastPrice);
        //     }
        // }

        // for (uint256 i = 0; i < 10000; i++) {
        //     if (i % 1000 == 0) {
        //         uint256 lastPrice = flip.calculatePrice(i, i+1000, false);
        //         console.log("i: ", i);
        //         console.log("price: ", lastPrice);
        //     }
        // }
    }
}
