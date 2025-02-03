// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/ITrade.sol";

/**
 * @title Registry Contract
 * @author @lukema95
 * @notice Registry of all the FLIP contracts
 */
contract Registry {
    error ContractAlreadyRegistered();
    error ContractDoesNotImplementITradeInterface();

    /// @notice Event emitted when a contract is registered
    event ContractRegistered(address creator, address contractAddress);

    /// @notice mapping creator to all contracts created by creator
    mapping(address => address[]) public creatorContracts;

    /// @notice mapping contract to creator
    mapping(address => address) public contractCreator;

    /// @notice Register a contract
    /// @param creator The creator of the contract
    /// @param contractAddress The address of the contract
    function register(address creator, address contractAddress) public {
        if (contractCreator[contractAddress] != address(0)) {
            revert ContractAlreadyRegistered();
        }
        // check if contract implements ITrade interface
        if (!ITrade(contractAddress).supportsInterface(type(ITrade).interfaceId)) {
            revert ContractDoesNotImplementITradeInterface();
        }

        creatorContracts[creator].push(contractAddress);
        contractCreator[contractAddress] = creator;

        emit ContractRegistered(creator, contractAddress);
    }

    function getCreatorContracts(address creator) public view returns (address[] memory) {
        return creatorContracts[creator];
    }

    function getContractCreator(address contractAddress) public view returns (address) {
        return contractCreator[contractAddress];
    }
}