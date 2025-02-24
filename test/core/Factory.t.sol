// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Factory} from "../../src/core/Factory.sol";
import {Registry} from "../../src/core/Registry.sol";
import {ITrade} from "../../src/interfaces/ITrade.sol";
import {IPrice} from "../../src/interfaces/IPrice.sol";

contract FactoryTest is Test {
    Factory public factory;
    Registry public registry;

    receive() external payable {}
    
    function setUp() public {
        registry = new Registry();
        factory = new Factory(address(registry));
    }

    function test_createFLIP() public {
        address contractAddress = factory.createFLIP("Flip", "FLIP", 0.001 ether, 10000, 0.05 ether, "https://flip.com/image.png");
        ITrade flip = ITrade(contractAddress);
        
        address expectedAddress = factory.calculateFLIPAddress("Flip", "FLIP", 0.001 ether, 10000, 0.05 ether);
        console.log("Deployed address:", address(flip));
        console.log("Expected address:", expectedAddress);
        assertEq(address(flip), expectedAddress);

        address[] memory creatorContracts = registry.getCreatorContracts(address(this));
        assertEq(creatorContracts.length, 1);
        assertEq(creatorContracts[0], expectedAddress);

        address creator = registry.getContractCreator(expectedAddress);
        assertEq(creator, address(this));

        address alice = address(0x1);
        vm.deal(alice, 1 ether);

        uint256 buyPrice = IPrice(contractAddress).getBuyPriceAfterFee();
        vm.prank(alice);
        flip.mint{value: buyPrice}();
        assertEq(flip.balanceOf(alice), 1);
    }

}
