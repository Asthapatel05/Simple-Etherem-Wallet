// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract SimpleEthereumWallet {
    address public owner;
    mapping(address => uint256) public balances;
    
    event Deposit(address indexed from, uint256 amount);
    event Withdrawal(address indexed to, uint256 amount);
    event Transfer(address indexed from, address indexed to, uint256 amount);
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }
    
    constructor() {
        owner = msg.sender;
    }
    
    // Function to deposit ETH into the wallet
    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than 0");
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }
    
    // Function to withdraw ETH from the wallet
    function withdraw(uint256 _amount) public {
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        require(_amount > 0, "Withdrawal amount must be greater than 0");
        
        balances[msg.sender] -= _amount;
        payable(msg.sender).transfer(_amount);
        emit Withdrawal(msg.sender, _amount);
    }
    
    // Function to transfer ETH to another address
    function transfer(address _to, uint256 _amount) public {
        require(_to != address(0), "Invalid recipient address");
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        require(_amount > 0, "Transfer amount must be greater than 0");
        
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
        emit Transfer(msg.sender, _to, _amount);
    }
    
    // Function to check balance of an address
    function getBalance(address _address) public view returns (uint256) {
        return balances[_address];
    }
    
    // Function to get contract's total balance
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
