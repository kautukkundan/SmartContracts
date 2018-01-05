pragma solidity^0.4.0;

contract CoinFlip {
    
    address owner;
    uint payPercentage = 90;
    
    event Status(string msg, address user, uint amount);
    
    function CoinFlip () payable {
        owner = msg.sender;
    }
    
    function FlipCoin () payable {
        if((block.timestamp%2)==0){
            if(this.balance < ((msg.value*payPercentage)/100)){
                Status("congratulations, you won, but we dont have enough money we are trandferring all of our balance",
                msg.sender, this.balance);
                msg.sender.transfer(this.balance); 
            } else {
                Status('congratulations, you won, we are sending you the money', msg.sender, msg.value*(100+payPercentage)/100);
                msg.sender.transfer(msg.value*(100+payPercentage)/100);
            }
        } else {
            Status("we are sorry, you loose", msg.sender, msg.value);
        }
    }
    
    modifier onlyOwner {
        if (msg.sender!=owner){
            revert();
        } else {
            _;
        }
    }
    
    function kill() onlyOwner {
        Status('contract killed an no longer available to use', msg.sender, this.balance);
        suicide(owner);
    }
    
}