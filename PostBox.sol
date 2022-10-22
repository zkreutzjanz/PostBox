// SPDX-License-Identifier: GPL-3.0
// compiler version must be greater than or equal to 0.8.13 and less than 0.9.0
pragma solidity ^0.8.13;

error unauthorized();

error transferFail(address dest,uint val);

error overflow(uint val1,uint val2);

error mismatch(uint val1,uint val2);

contract PostBox {

    mapping(address => uint) users;

    address minter;

    constructor(){
        minter=msg.sender;
    }

    function peek() public view returns (uint) {
        return users[msg.sender];
    }

    function deposit(address _addr) public payable {
        if(msg.sender!=minter) 
            revert unauthorized();

        if(users[_addr]+msg.value<msg.value)
            revert overflow(users[_addr],msg.value);
        users[_addr] += msg.value;
    }
    
    function multiDeposit(address[] memory addresses,uint[] memory amounts) public payable{
        if(msg.sender!=minter) 
            revert unauthorized();
        uint amountAdded=0;
        for(uint i=0;i<addresses.length;i++){
            users[addresses[i]] += amounts[i];
            amountAdded +=amounts[i];
        }
        if(msg.value!=amountAdded)
            revert mismatch(msg.value,amountAdded);
    }

    function retrieve() public{
        (bool success, ) = payable(msg.sender).call{value: users[msg.sender]}("");
        if(!success)
            revert transferFail(msg.sender,users[msg.sender]);
        users[msg.sender]=0;
    }
}