
// compiler version must be greater than or equal to 0.8.13 and less than 0.9.0
pragma solidity ^0.8.13;

contract PostBox {
    mapping(address => uint) recievers;
    address owner;

    constructor(){
        owner=msg.sender;
    }
    function peek() public view returns (uint) {
        return recievers[msg.sender];
    }

    function deposit(address _addr) public payable {
        recievers[_addr] = recievers[_addr]+msg.value;
    }

    function retrieve() public{
        (bool success, ) = msg.sender.call{value: recievers[msg.sender]}("");
        require(success, "Failed to send Ether");
    }

    function clear() public{
        if(msg.sender==owner){
            (bool success, ) = msg.sender.call{value: address(this).balance}("");
            require(success, "Failed to send Ether");
        }
    }
}