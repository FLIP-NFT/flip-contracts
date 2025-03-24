// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../core/Trade.sol";
import "./Trait.sol";

/**
 * @title FlipNFT Contract
 * @author @lukema95
 * @notice FlipNFT contract is a FLIP contract which implements Trade and Trait
 */
contract FlipNFT is Trade, Trait {
    using Strings for uint256;

    constructor(
        address _feeVault,
        string memory _name,
        string memory _symbol,
        uint256 _initialPrice,  
        uint256 _maxSupply,
        uint256 _creatorFeePercent
    ) Trade(_feeVault, _name, _symbol, _initialPrice, _maxSupply, _creatorFeePercent) {}

    function mint() public payable override returns (uint256) {
        uint256 tokenId = totalSupply() + 1;
        super.mint();
        tokenSeed[tokenId] = block.timestamp;

        return tokenId;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        uint256 combinedSeed = uint256(keccak256(abi.encodePacked(tokenSeed[tokenId], tokenId)));
        string memory svg = generateRandomSVG(combinedSeed);
        
        string memory json = Base64.encode(
            bytes(string(abi.encodePacked(
                '{"description": "FlipNFT is the first Bonding Curve NFT.", "image": "data:image/svg+xml;base64,',
                Base64.encode(bytes(svg)),
                '"}'
            )))
        );

        return string(abi.encodePacked("data:application/json;base64,", json));
    }

    receive() external payable {}
}