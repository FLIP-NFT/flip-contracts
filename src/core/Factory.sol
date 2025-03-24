// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Registry.sol";
import "./FeeVault.sol";
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
    FeeVault public feeVault;

    constructor(address _registry, address _feeVault) {
        registry = Registry(_registry);
        feeVault = FeeVault(payable(_feeVault));
    }

    /// @notice Create a FLIP contract
    /// @param _name The name of the FLIP
    /// @param _symbol The symbol of the FLIP
    /// @param _initialPrice The initial price of the FLIP
    /// @param _maxSupply The maximum supply of the FLIP
    /// @param _creatorFeePercent The creator fee percent of the FLIP
    /// @param _imageUrl The image url of the FLIP
    /// @return The address of the FLIP contract
    function createFLIP(
        string memory _name,
        string memory _symbol,
        uint256 _initialPrice,
        uint256 _maxSupply,
        uint256 _creatorFeePercent,
        string memory _imageUrl
    ) public returns (address) {
        bytes32 salt = keccak256(abi.encode(
            address(feeVault),
            _name,
            _symbol,
            _initialPrice,
            _maxSupply,
            _creatorFeePercent
        ));

        Trade trade = new Trade{salt: salt}(
            address(feeVault),
            _name,
            _symbol,
            _initialPrice,
            _maxSupply,
            _creatorFeePercent
        );

        if (bytes(_imageUrl).length > 0) {
            trade.setBaseURI(_imageUrl);
        }

        // transfer ownership to msg.sender
        trade.transferOwnership(msg.sender);
        require(trade.owner() == msg.sender, "Owner mismatch");

        // set creator to msg.sender
        trade.setCreator(msg.sender);
        require(trade.creator() == msg.sender, "Creator mismatch");

        emit FLIPCreated(msg.sender, address(trade));
        
        registry.register(msg.sender, address(trade));
        return address(trade);
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
        bytes32 salt = keccak256(abi.encode(
            address(feeVault),
            _name,
            _symbol,
            _initialPrice,
            _maxSupply,
            _creatorFeePercent
        ));
        
        bytes memory initParams = abi.encode(
            address(feeVault),
            _name,
            _symbol,
            _initialPrice,
            _maxSupply,
            _creatorFeePercent
        );
        

        bytes32 hash = keccak256(
            abi.encodePacked(
                bytes1(0xff),
                address(this),
                salt,
                keccak256(abi.encodePacked(
                    type(Trade).creationCode,
                    initParams
                ))
            )
        );

        return address(uint160(uint256(hash)));
    }
}
