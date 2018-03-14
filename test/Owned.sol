pragma solidity ^0.4.18;

contract Owned {
    address public owner;
    
    modifier onlyOwner {
        if (msg.sender != owner) {
            assert(true);
        }
        _;
    }

    function Owned() public {
        owner = msg.sender;
    }
    function transferOwnership(
        address newOwner
    ) 
        public
        onlyOwner
        {
        owner = newOwner;
    }
    
}
