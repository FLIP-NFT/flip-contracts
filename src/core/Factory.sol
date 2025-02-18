// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Registry.sol";
import "./Trade.sol";

/**
 * @title Factory Contract
 * @author @lukema95
 * @notice Factory contract for creating FLIP contracts
 */
contract Factory {

    /// @notice Event emitted when a FLIP contract is created
    event FLIPCreated(address indexed creator, address indexed flipAddress);

    Registry public registry;

    constructor(address _registry) {
        registry = Registry(_registry);
    }

    /// @notice Create a FLIP contract
    /// @param _name The name of the FLIP
    /// @param _symbol The symbol of the FLIP
    /// @param _initialPrice The initial price of the FLIP
    /// @param _maxSupply The maximum supply of the FLIP
    /// @param _creatorFeePercent The creator fee percent of the FLIP
    /// @param _imageUrl The image url of the FLIP
    /// @param _description The description of the FLIP
    /// @return The address of the FLIP contract
    function createFLIP(
        string memory _name,
        string memory _symbol,
        uint256 _initialPrice,
        uint256 _maxSupply,
        uint256 _creatorFeePercent,
        string memory _imageUrl,
        string memory _description
    ) public returns (address) {
        bytes32 salt = keccak256(
            abi.encodePacked(
                _name,
                _symbol,
                _initialPrice,
                _maxSupply,
                _creatorFeePercent,
                msg.sender
            )
        );

        bytes memory creationCode = abi.encodePacked(
            type(Trade).creationCode,
            abi.encode(
                _name,
                _symbol,
                _initialPrice,
                _maxSupply,
                _creatorFeePercent,
                msg.sender
            )
        );

        address trade;
        assembly {
            trade := create2(0, add(creationCode, 0x20), mload(creationCode), salt)
        }
        require(trade != address(0), "Create2: Failed on deploy");
        
        Trade tradeContract = Trade(trade);

        if (bytes(_imageUrl).length > 0) {
            tradeContract.setBaseURI(_imageUrl);
        }

        if (bytes(_description).length > 0) {
            tradeContract.setDescription(_description);
        }

        // set creator to msg.sender
        tradeContract.setCreator(msg.sender);
        require(tradeContract.creator() == msg.sender, "Creator mismatch");

        emit FLIPCreated(msg.sender, trade);
        
        registry.register(msg.sender, trade);
        return trade;
    }

    /// @notice Calculate the address of a FLIP contract
    /// @param _name The name of the FLIP
    /// @param _symbol The symbol of the FLIP
    /// @param _initialPrice The initial price of the FLIP
    /// @param _maxSupply The maximum supply of the FLIP
    /// @param _creatorFeePercent The creator fee percent of the FLIP
    /// @return The address of the FLIP contract
    function calculateFLIPAddress(
        string memory _name,  
        string memory _symbol,
        uint256 _initialPrice,
        uint256 _maxSupply,
        uint256 _creatorFeePercent
    ) public view returns (address) {
        bytes32 salt = keccak256(
            abi.encodePacked(
                _name,
                _symbol,
                _initialPrice,
                _maxSupply,
                _creatorFeePercent,
                msg.sender
            )
        );
        
        bytes memory creationCode = abi.encodePacked(
            type(Trade).creationCode,
            abi.encode(
                _name,
                _symbol,
                _initialPrice,
                _maxSupply,
                _creatorFeePercent,
                msg.sender
            )
        );
        
        return address(uint160(uint256(keccak256(abi.encodePacked(
            bytes1(0xff),
            address(this),
            salt,
            keccak256(creationCode)
        )))));
    }
}
