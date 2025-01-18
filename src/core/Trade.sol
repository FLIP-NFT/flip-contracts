// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Price.sol";

contract Trade is Price {
    event TokenMinted(address indexed to, uint256 indexed tokenId, uint256 price, uint256 creatorFee);
    event TokenBought(address indexed buyer, uint256 indexed tokenId, uint256 price, uint256 creatorFee);
    event TokenSold(address indexed seller, uint256 indexed tokenId, uint256 price, uint256 creatorFee);
    // event QuickBuyExecuted(address indexed buyer, uint256 indexed tokenId, uint256 price);

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _initialPrice,
        uint256 _maxSupply,
        uint256 _creatorFeePercent
    ) Price(_name, _symbol, _initialPrice, _maxSupply, _creatorFeePercent) {}

    modifier onlyTokenOwner(uint256 tokenId) {
        require(ownerOf(tokenId) == _msgSender(), "Caller is not owner");
        _;
    }

    modifier onlyTokenOnSale(uint256 tokenId) {
        require(ownerOf(tokenId) == address(this), "Token is not available for sale");
        _;
    }

    function mint() public virtual payable {
        require(totalSupply() < maxSupply, "Max supply reached");

        uint256 price = getBuyPrice();
        uint256 creatorFee = (price * creatorFeePercent) / 1 ether;
        require(msg.value >= price + creatorFee, "Insufficient payment");

        uint256 tokenId = totalSupply() + 1;

        _safeMint(msg.sender, tokenId);
        ++currentSupply;

        emit TokenMinted(msg.sender, tokenId, price, creatorFee);

        (bool success, ) = creator.call{value: creatorFee}("");
        require(success, "Transfer failed");

        _refundExcess(price + creatorFee);
    }

    function buy(uint256 tokenId) public payable onlyTokenOnSale(tokenId) {
        uint256 price = getBuyPrice(); 
        uint256 creatorFee = price * creatorFeePercent / 1 ether;
        require(msg.value >= price + creatorFee, "Insufficient payment");

        _transfer(address(this), msg.sender, tokenId);

        removeAvailableToken(tokenId);
        ++currentSupply;

        emit TokenBought(msg.sender, tokenId, price, creatorFee);

        (bool success, ) = creator.call{value: creatorFee}("");
        require(success, "Transfer failed");

        _refundExcess(price + creatorFee);
    }

    // function quickBuy() public payable {
    //     require(availableTokens.length > 0, "No tokens available for quick buy");
    //     uint256 tokenId = availableTokens[availableTokens.length - 1];
        
    //     buy(tokenId);
        
    //     emit QuickBuyExecuted(msg.sender, tokenId, getBuyPrice());
    // }

    function sell(uint256 tokenId) public onlyTokenOwner(tokenId) {
        uint256 price = getSellPrice();
        uint256 creatorFee = price * creatorFeePercent / 1 ether;

        _transfer(_msgSender(), address(this), tokenId);
        addAvailableToken(tokenId);
        --currentSupply;

        emit TokenSold(_msgSender(), tokenId, price, creatorFee);

        (bool sentToSeller, ) = _msgSender().call{value: price - creatorFee}("");
        require(sentToSeller, "Transfer to seller failed");

        (bool sentToCreator, ) = creator.call{value: creatorFee}("");
        require(sentToCreator, "Transfer to creator failed");
    }

    function isOnSale(uint256 tokenId) public view returns (bool) {
        return ownerOf(tokenId) == address(this);
    }

    function _refundExcess(uint256 price) internal {
        uint256 refundAmount = msg.value - price;
        if (refundAmount > 0) {
            (bool success, ) = _msgSender().call{value: refundAmount}("");
            require(success, "Refund failed");
        }
    }
}
