// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Price.sol";
import "./FeeVault.sol";
import "../interfaces/ITrade.sol";

/**
 * @title Trade
 * @author @lukema95
 * @notice Trade contract for FLIPs, implements ITrade interface
 */
contract Trade is ITrade, Price {
    FeeVault public feeVault;
    constructor(
        address _feeVault,
        string memory _name,
        string memory _symbol,
        uint256 _initialPrice,
        uint256 _maxSupply,
        uint256 _creatorFeePercent
    ) Price(_name, _symbol, _initialPrice, _maxSupply, _creatorFeePercent) {
        feeVault = FeeVault(payable(_feeVault));
    }

    modifier onlyTokenOwner(uint256 tokenId) {
        require(ownerOf(tokenId) == _msgSender(), "Caller is not owner");
        _;
    }

    modifier onlyTokenOnSale(uint256 tokenId) {
        require(ownerOf(tokenId) == address(this), "Token is not available for sale");
        _;
    }

    function mint() public virtual payable returns (uint256) {
        require(totalSupply() < maxSupply, "Max supply reached");

        uint256 price = getBuyPrice();
        uint256 creatorFee = (price * creatorFeePercent) / 1 ether;
        require(msg.value >= price + creatorFee, "Insufficient payment");

        uint256 tokenId = totalSupply() + 1;

        _safeMint(msg.sender, tokenId);
        ++currentSupply;

        emit TokenMinted(msg.sender, tokenId, price, creatorFee);

        distributeFee(creatorFee);

        _refundExcess(price + creatorFee);

        return tokenId;
    }

    function buy(uint256 tokenId) public payable onlyTokenOnSale(tokenId) {
        uint256 price = getBuyPrice(); 
        uint256 creatorFee = price * creatorFeePercent / 1 ether;
        require(msg.value >= price + creatorFee, "Insufficient payment");

        _transfer(address(this), msg.sender, tokenId);

        removeAvailableToken(tokenId);
        ++currentSupply;

        emit TokenBought(msg.sender, tokenId, price, creatorFee);

        distributeFee(creatorFee);

        _refundExcess(price + creatorFee);
    }

    function sell(uint256 tokenId) public onlyTokenOwner(tokenId) {
        uint256 price = getSellPrice();
        uint256 creatorFee = price * creatorFeePercent / 1 ether;

        _transfer(_msgSender(), address(this), tokenId);
        addAvailableToken(tokenId);
        --currentSupply;

        emit TokenSold(_msgSender(), tokenId, price, creatorFee);

        (bool sentToSeller, ) = _msgSender().call{value: price - creatorFee}("");
        require(sentToSeller, "Transfer to seller failed");

        distributeFee(creatorFee);
    }

    function isOnSale(uint256 tokenId) public view returns (bool) {
        return ownerOf(tokenId) == address(this);
    }

    function distributeFee(uint256 fee) internal {
        uint256 protocolFee = (fee * feeVault.PROTOCOL_FEE_PERCENT()) / 1 ether;
        uint256 creatorFee = fee - protocolFee;

        (bool success, ) = creator.call{value: creatorFee}("");
        require(success, "Transfer fee to creator failed");

        (bool successProtocol, ) = address(feeVault).call{value: protocolFee}("");
        require(successProtocol, "Transfer fee to protocol failed");
    }

    function _refundExcess(uint256 price) internal {
        uint256 refundAmount = msg.value - price;
        if (refundAmount > 0) {
            (bool success, ) = _msgSender().call{value: refundAmount}("");
            require(success, "Refund failed");
        }
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(BaseNFT, IERC165) returns (bool) {
        return super.supportsInterface(interfaceId) || interfaceId == type(ITrade).interfaceId;
    }
}