// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Registry} from "../../src/core/Registry.sol";
import {Trade} from "../../src/core/Trade.sol";
import {FeeVault} from "../../src/core/FeeVault.sol";

contract MockContract {
    function supportsInterface(bytes4) public pure returns (bool) {
        return false;
    }
}

contract RegistryTest is Test {
    Registry public registry;
    FeeVault public feeVault;

    function setUp() public {
        feeVault = new FeeVault();
        registry = new Registry();
    }

    function test_register() public {
        Trade trade = new Trade(address(feeVault), "Flip", "FLIP", 0.001 ether, 10000, 0.05 ether);
        registry.register(address(this), address(trade));
        address[] memory creatorContracts = registry.getCreatorContracts(address(this));
        assertEq(creatorContracts.length, 1);
        assertEq(creatorContracts[0], address(trade));

        address creator = registry.getContractCreator(address(trade));
        assertEq(creator, address(this));
    }

    function test_RevertWhen_ContractAlreadyRegistered() public {
        Trade trade = new Trade(address(feeVault), "Flip", "FLIP", 0.001 ether, 10000, 0.05 ether);
        registry.register(address(this), address(trade));
        vm.expectRevert(Registry.ContractAlreadyRegistered.selector);
        registry.register(address(this), address(trade));
    }

    function test_RevertWhen_ContractDoesNotImplementITradeInterface() public {
        MockContract mockContract = new MockContract();
        
        vm.expectRevert(Registry.ContractDoesNotImplementITradeInterface.selector);
        registry.register(address(this), address(mockContract));
    }
}
