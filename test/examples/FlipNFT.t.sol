// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {FlipNFT} from "../../src/examples/FlipNFT.sol";

contract FlipTest is Test {
    receive() external payable {}

    FlipNFT public flip;

    address alice = address(0x1);
    address bob = address(0x2);
    address carol = address(0x3);

    function setUp() public {
        vm.prank(alice);
        flip = new FlipNFT(
            "Flip",
            "FLIP",
            0.001 ether,
            10000,
            0.05 ether
        );
    }

    function test_setCreator() public {
        vm.prank(alice);
        flip.setCreator(bob);
        assertEq(flip.creator(), bob);
    }

    function test_RevertWhen_SetCreatorNotOwner() public {
        vm.prank(bob);
        vm.expectRevert();
        flip.setCreator(bob);
    }

    function test_mint() public {
        vm.deal(bob, 10000 ether);
        uint256 totalPrice = 0;
        uint256 totalPriceAfterFee = 0;
        uint256 totalCreatorFee = 0;
        console.log("================================================");
        for (uint256 i = 0; i < 10000; i++) {
            uint256 price = flip.getBuyPrice();
            uint256 priceAfterFee = flip.getBuyPriceAfterFee();
            vm.prank(bob);
            flip.mint{value: priceAfterFee}();
            totalPrice += price;
            totalPriceAfterFee += priceAfterFee;
            totalCreatorFee += price * flip.creatorFeePercent() / 1 ether;
            if (i % 1000 == 0 || i == 1 || i == 10000) {
                console.log("index:         ", i + 1);
                console.log("price:         ", price);
                console.log("priceAfterFee: ", priceAfterFee);
                console.log("currentSupply: ", flip.currentSupply());
                console.log("totalSupply:   ", flip.totalSupply());
                console.log("----------------------------------------");
            }
        }
        assertEq(flip.totalSupply(), 10000);
        assertEq(flip.currentSupply(), 10000);
        assertEq(flip.balanceOf(bob), 10000);
        assertEq(address(flip).balance, totalPrice);

        console.log("totalPrice:         ||", totalPrice);
        console.log("totalCreatorFee:    ||", totalCreatorFee);
        console.log("totalPriceAfterFee: ||", totalPriceAfterFee);
        assertEq(address(alice).balance, totalCreatorFee);
        assertEq(totalPriceAfterFee, totalPrice + totalCreatorFee);
    }

    function test_sell() public {
        test_mint();
        
        uint256 bobBalanceBeforeSell = bob.balance;
        uint256 contractBalanceBeforeSell = address(flip).balance;
        uint256 creatorBalanceBeforeSell = address(alice).balance;
        for (uint256 i = 1; i <= 10000; i++) {
            vm.prank(bob);
            flip.sell(i);
        }
        uint256 bobBalanceAfterSell = bob.balance;
        uint256 contractBalanceAfterSell = address(flip).balance;
        uint256 creatorBalanceAfterSell = address(alice).balance;

        console.log("Bob Balance before sell      ", bobBalanceBeforeSell);
        console.log("Bob Balance after sell       ", bobBalanceAfterSell);
        
        console.log("Contract Balance before sell ", contractBalanceBeforeSell);
        console.log("Contract Balance after sell  ", contractBalanceAfterSell);
        
        console.log("Creator Balance before sell  ", creatorBalanceBeforeSell);
        console.log("Creator Balance after sell   ", creatorBalanceAfterSell);

        uint256 diffContractBalance = contractBalanceBeforeSell - contractBalanceAfterSell;
        uint256 diffBobBalance = bobBalanceAfterSell - bobBalanceBeforeSell;
        uint256 diffCreatorBalance = creatorBalanceAfterSell - creatorBalanceBeforeSell;
        
        assertEq(diffContractBalance, diffBobBalance + diffCreatorBalance);

        uint256 tokensCount = flip.getAvailableTokensCount();
        console.log("available tokens count", tokensCount);
        assertEq(tokensCount, 10000);
    }

    function test_RevertWhen_SellWithTokenNotOwned() public {
        test_mint();
        vm.prank(bob);
        flip.sell(1);

        vm.prank(carol);
        uint256 price = flip.getBuyPriceAfterFee();
        flip.buy{value: price}(1);

        vm.prank(bob);
        vm.expectRevert("Caller is not owner");
        flip.sell(1);
    }

    function test_buy() public {
        test_sell();

        console.log("================================================");
        uint256 availableTokensCountBeforeBuy    = flip.getAvailableTokensCount();
        console.log("available tokens count before buy", availableTokensCountBeforeBuy);
        
        vm.deal(carol, 1 ether);
        vm.prank(carol);
        uint256 price = flip.getBuyPriceAfterFee();
        flip.buy{value: price}(1);

        uint256 availableTokensCountAfterBuy = flip.getAvailableTokensCount();
        console.log("available tokens count after buy", availableTokensCountAfterBuy);
        assertEq(availableTokensCountAfterBuy, availableTokensCountBeforeBuy - 1);
    }

    function test_RevertWhen_BuyWithTokenNotAvailable() public {
        test_mint();

        vm.deal(carol, 10 ether);
        vm.prank(carol);
        uint256 price = flip.getBuyPriceAfterFee();
        vm.expectRevert("Token is not available for sale");
        flip.buy{value: price}(1);
    }

    function test_deal() public {
        vm.deal(bob, 10000 ether);
        // mint all
        console.log("================================================");
        uint256 bobBalanceBeforeMint = bob.balance;
        uint256 contractBalanceBeforeMint = address(flip).balance;
        for (uint256 i = 0; i < 10000; i++) {
            uint256 price = flip.getBuyPriceAfterFee();
            vm.prank(bob);
            flip.mint{value: price}();
        }

        uint256 contractBalanceAfterMint = address(flip).balance;
        uint256 bobBalanceAfterMint = bob.balance;
        
        console.log("Bob Balance before mint     ", bobBalanceBeforeMint);
        console.log("Bob Balance after mint      ", bobBalanceAfterMint);
        console.log("Contract Balance before mint", contractBalanceBeforeMint);
        console.log("Contract Balance after mint ", contractBalanceAfterMint);

        // sell 1000
        console.log("================================================");
        uint256 creatorBalanceBeforeSell = address(alice).balance;
        uint256 bobBalanceBeforeSell = bob.balance;
        uint256 contractBalanceBeforeSell = address(flip).balance;
        uint256 totalSellPriceAfterFee = 0;
        uint256 totalSellPrice = 0;
        uint256 totalCreatorSellFee = 0;
        for (uint256 i = 1; i <= 2000; i++) {
            uint256 sellPrice = flip.getSellPrice();
            uint256 sellPriceAfterFee = flip.getSellPriceAfterFee();
            
            vm.prank(bob);
            flip.sell(i);
            
            totalSellPriceAfterFee += sellPriceAfterFee;
            totalSellPrice += sellPrice;
            totalCreatorSellFee += sellPrice * flip.creatorFeePercent() / 1 ether;
            
            if (i % 500 == 0 || i == 1 || i == 2000) {
                console.log("Token ID:            ", i);
                console.log("Creator Fee:         ", sellPrice * flip.creatorFeePercent() / 1 ether);
                console.log("Sell Price:          ", sellPrice);
                console.log("Sell Price After Fee:", sellPriceAfterFee);
                assertEq(sellPrice, sellPriceAfterFee + sellPrice * flip.creatorFeePercent() / 1 ether);
                console.log("----------------------------------------");
            }
        }
        uint256 contractBalanceAfterSell = address(flip).balance;
        uint256 bobBalanceAfterSell = bob.balance;
        uint256 creatorBalanceAfterSell = address(alice).balance;

        console.log("Bob Balance before sell      ", bobBalanceBeforeSell);
        console.log("Bob Balance after sell       ", bobBalanceAfterSell);
        
        console.log("Contract Balance before sell ", contractBalanceBeforeSell);
        console.log("Contract Balance after sell  ", contractBalanceAfterSell);
        
        console.log("Total Creator Fee            ", totalCreatorSellFee);
        console.log("Creator Balance before sell  ", creatorBalanceBeforeSell);
        console.log("Creator Balance after sell   ", creatorBalanceAfterSell);
        
        assertEq(bobBalanceAfterSell, bobBalanceBeforeSell + totalSellPriceAfterFee);
        assertEq(creatorBalanceAfterSell, creatorBalanceBeforeSell + totalCreatorSellFee);
        assertEq(contractBalanceAfterSell, contractBalanceBeforeSell - totalSellPrice);
        assertEq(totalSellPrice, totalSellPriceAfterFee + totalCreatorSellFee);

        // buy 200
        console.log("================================================");
        vm.deal(carol, 100000 ether);
        uint256 carolBalanceBeforeBuy = carol.balance;
        uint256 contractBalanceBeforeBuy = address(flip).balance;
        uint256 creatorBalanceBeforeBuy = address(alice).balance;

        uint256 totalBuyPriceAfterFee = 0;
        uint256 totalBuyPrice = 0;
        uint256 totalCreatorBuyFee = 0;
        for (uint256 i = 1; i <= 2000; i++) {
            uint256 buyPrice = flip.getBuyPrice();
            uint256 buyPriceAfterFee = flip.getBuyPriceAfterFee();
            
            vm.prank(carol);
            flip.buy{value: buyPriceAfterFee}(i);

            totalBuyPriceAfterFee += buyPriceAfterFee;
            totalBuyPrice += buyPrice;
            totalCreatorBuyFee += buyPrice * flip.creatorFeePercent() / 1 ether;
            
            if (i % 500 == 0 || i == 1 || i == 2000) {
                console.log("index:            ", i);
                console.log("buyPrice:         ", buyPrice);
                console.log("creatorFee:       ", buyPrice * flip.creatorFeePercent() / 1 ether);
                console.log("buyPriceAfterFee: ", buyPriceAfterFee);
                assertEq(buyPrice, buyPriceAfterFee - buyPrice * flip.creatorFeePercent() / 1 ether);
                console.log("----------------------------------------");

            }
        }
        uint256 contractBalanceAfterBuy = address(flip).balance;
        uint256 carolBalanceAfterBuy = carol.balance;
        uint256 creatorBalanceAfterBuy = address(alice).balance;

        console.log("Carol Balance before buy   ", carolBalanceBeforeBuy);
        console.log("Carol Balance after buy    ", carolBalanceAfterBuy);
        
        console.log("Contract Balance before buy", contractBalanceBeforeBuy);
        console.log("Contract Balance after buy ", contractBalanceAfterBuy);
        
        console.log("Total Creator Buy Fee      ", totalCreatorBuyFee);
        console.log("Creator Balance before buy ", creatorBalanceBeforeBuy);
        console.log("Creator Balance after buy  ", creatorBalanceAfterBuy);

        assertEq(carolBalanceAfterBuy, carolBalanceBeforeBuy - totalBuyPriceAfterFee);
        assertEq(creatorBalanceAfterBuy, creatorBalanceBeforeBuy + totalCreatorBuyFee);
        assertEq(contractBalanceAfterBuy, contractBalanceBeforeBuy + totalBuyPrice);
        assertEq(totalBuyPrice, totalBuyPriceAfterFee - totalCreatorBuyFee);

        /*
        // sell 1000
        console.log("================================================");
        contractBalanceBeforeSell = address(flip).balance;
        creatorBalanceBeforeSell = address(alice).balance;
        uint256 carolBalanceBeforeSell = carol.balance;

        totalSellPriceAfterFee = 0;
        totalSellPrice = 0;
        totalCreatorSellFee = 0;
        for (uint256 i = 1; i <= 1000; i++) {
            uint256 sellPrice = flip.getSellPrice();
            uint256 sellPriceAfterFee = flip.getSellPriceAfterFee();
            
            vm.prank(carol);
            flip.sell(i);
            
            totalSellPriceAfterFee += sellPriceAfterFee;
            totalSellPrice += sellPrice;
            totalCreatorSellFee += sellPrice * flip.creatorFeePercent() / 1 ether;
            
            if (i % 100 == 0 || i == 1 || i == 1000) {
                console.log("index:             ", i);
                console.log("sellPriceAfterFee: ", sellPriceAfterFee);
                console.log("creatorFee:        ", sellPrice * flip.creatorFeePercent() / 1 ether);
                console.log("sellPrice:         ", sellPrice);
                assertEq(sellPrice, sellPriceAfterFee + sellPrice * flip.creatorFeePercent() / 1 ether);
                console.log("----------------------------------------");
            }
        }

        contractBalanceAfterSell = address(flip).balance;
        creatorBalanceAfterSell = address(alice).balance;
        uint256 carolBalanceAfterSell = carol.balance;

        console.log("Carol Balance before sell   ", carolBalanceBeforeSell);
        console.log("Carol Balance after sell    ", carolBalanceAfterSell);
        
        console.log("Contract Balance before sell ", contractBalanceBeforeSell);
        console.log("Contract Balance after sell  ", contractBalanceAfterSell);
        
        console.log("Total Creator Sell Fee      ", totalCreatorSellFee);
        console.log("Creator Balance before sell  ", creatorBalanceBeforeSell);
        console.log("Creator Balance after sell   ", creatorBalanceAfterSell);

        assertEq(carolBalanceAfterSell, carolBalanceBeforeSell + totalSellPriceAfterFee);
        assertEq(creatorBalanceAfterSell, creatorBalanceBeforeSell + totalCreatorSellFee);
        assertEq(contractBalanceAfterSell, contractBalanceBeforeSell - totalSellPrice);
        assertEq(totalSellPrice, totalSellPriceAfterFee + totalCreatorSellFee);
        */
    }

    function testPriceCurve() public view {
        console.log("Price at 0     supply:", flip.calculatePrice(0));
        console.log("Price at 500   supply:", flip.calculatePrice(500));
        console.log("Price at 1000  supply:", flip.calculatePrice(1000));
        console.log("Price at 2500  supply:", flip.calculatePrice(2500));
        console.log("Price at 5000  supply:", flip.calculatePrice(5000));
        console.log("Price at 7500  supply:", flip.calculatePrice(7500));
        console.log("Price at 10000 supply:", flip.calculatePrice(10000));
    }

    function testPriceBySupply() public view {
        for (uint256 i = 1; i <= 10000; i+=100) {
            console.log("Price at ", i, " supply:", flip.calculatePrice(i));
        }
    }

    function test_tokenURI() public view {
        console.log(flip.tokenURI(3));
    }
}
