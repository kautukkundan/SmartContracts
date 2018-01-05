pragma solidity^0.4.0;

contract LastWill {
    
    address owner;
    
    uint256 public lastTouch;
    
    address[] public childs;
    
    event Status(string msg, address user, uint256 time);
    
    function LastWill() payable {
        owner = msg.sender;
        lastTouch = block.timestamp;
        Status('LastWill created', msg.sender, block.timestamp);
    }
    
    function depositFunds() payable {
        Status('funds deposited', msg.sender, block.timestamp);
    }
    
    function stillAlive() {
        lastTouch = block.timestamp;
        Status('I am alive', msg.sender, block.timestamp);
    }
    
    function isDead() {
        Status('Someone is checking if is dead', msg.sender, block.timestamp);
        if(block.timestamp > (lastTouch+120)){
            giveMoneyToChild();
        } else {
            Status('I am still Alive', msg.sender, block.timestamp);
        }
    }
    
    function giveMoneyToChild(){
        Status('i am dead', msg.sender, block.timestamp);
        uint amountPerChild = this.balance/childs.length;
        for (uint i =0; i < childs.length; i++){
            childs[i].transfer(amountPerChild);
        }
        
    }
    
    function addChilds(address childAddress) onlyOwner {
        Status('Child Addded', childAddress, block.timestamp);    
        childs.push(childAddress);
    }
    
    modifier onlyOwner {
        if (msg.sender!=owner){
            revert();
        } else {
            _;
        }
    }
    
}