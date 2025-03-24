// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FeeVault {
    address public admin;
    uint256 public constant PROTOCOL_FEE_PERCENT = 0.2 ether; // 20%
    
    event AdminChanged(address indexed previousAdmin, address indexed newAdmin);
    event FeeWithdrawn(address indexed recipient, uint256 amount);
    
    constructor() {
        admin = msg.sender;
    }
    
    modifier onlyAdmin() {
        require(msg.sender == admin, "FeeVault: caller is not admin");
        _;
    }
    
    function setAdmin(address newAdmin) external onlyAdmin {
        require(newAdmin != address(0), "FeeVault: new admin is zero address");
        address oldAdmin = admin;
        admin = newAdmin;
        emit AdminChanged(oldAdmin, newAdmin);
    }
    
    function withdrawFees(address recipient, uint256 amount) external onlyAdmin {
        require(recipient != address(0), "FeeVault: recipient is zero address");
        require(amount > 0, "FeeVault: amount must be greater than 0");
        require(amount <= address(this).balance, "FeeVault: insufficient balance");
        
        (bool success, ) = recipient.call{value: amount}("");
        require(success, "FeeVault: transfer failed");
        
        emit FeeWithdrawn(recipient, amount);
    }
    
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
    
    receive() external payable {}
}