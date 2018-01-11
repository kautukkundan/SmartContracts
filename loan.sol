pragma solidity^0.4.0;

contract Loan {
    
    address [] public communityMembers;
    mapping (address=>uint256) public amountRequested;
    mapping (address=>uint) public agreed;
    mapping (address=>uint) public disagreed;
    mapping (address=>uint) public duration;
    mapping (address=>string) public reasons;
    mapping (address=>string) public loanStatus;
    mapping (address=>uint256) public balances;
    mapping (address=>uint256) public repayAmount;
    mapping (address=>uint) public creditPoints;
    
    uint rate = 10;
    
    event status(string msgs);
    event status2(uint val);
    
    function joinCommunity () payable public {
        communityMembers.push(msg.sender);
        balances[msg.sender]+=msg.value;
    }
    
    function appealLoan(uint256 amt, uint dur, string reason) public {
        amountRequested[msg.sender] = amt;
        duration[msg.sender] = dur;
        reasons[msg.sender] = reason;
        loanStatus[msg.sender] = "pending";
    }
    
    function agree(address add) public {
        if(validUser(msg.sender)){
            agreed[add]+=1;
        }
        else {
            status("You cannot vote for this member");
        }
    }
    
    function disagree(address add) public {
        if(validUser(msg.sender)){
            disagreed[add]+=1;
        }
        else {
            status("You cannot vote for this member");
        }
    }
    
    function validUser(address add) private returns (bool){
        for(uint i=0; i < communityMembers.length; i++){
            if(communityMembers[i]==add){
                return true;
            }
        }
        return false;
    }
    
    
    function getVotesDisagree(address add) public constant returns (uint){
        if(validUser(add)==false){
           status("you cannot view votes"); 
        }
        else {
            return disagreed[add];
        }
    }
    
    function getVotesAgree(address add) public constant returns (uint){
        if(validUser(add)==false){
           status("you cannot view votes"); 
        }
        else {
            return agreed[add];
        }
    }
    
    function grantLoan(address add) {
        uint256 amount = amountRequested[add] / (communityMembers.length-1);
        if(creditPoints[add]>=0){
        for(uint i =0; i < communityMembers.length; i++){
            address addA=communityMembers[i];
                if (addA==add){
                status("cant give");
            }
            else {
                balances[addA]-=amount;
                status("given");
            }
        }
        balances[add]+=amountRequested[add];
        repayAmount[add]=amountRequested[add]+amountRequested[add]*10/100;
    }
        else{
            status("you dont seem a nice guy");
        }
    }
    
    function loanSanction(address add) private {
        if(getVotesAgree(add)>communityMembers.length/2){
            grantLoan(add);
            loanStatus[add] = "approved";
        }
        else if(getVotesDisagree(add)>communityMembers.length/2){
            loanStatus[add] = "rejected";
        }
    }
    
    function getLoanStatus(address add) public constant returns(string){
        loanSanction(add);
        return loanStatus[add];
    }
    
    function getBalance() constant returns(uint256){
        return balances[msg.sender];
    }
    
    function getCreditPoints() constant returns(uint){
        return creditPoints[msg.sender];
    }
    
    function repayLoan() public{
        uint repayAmountPerPerson=repayAmount[msg.sender]/(communityMembers.length-1);
        status2(repayAmountPerPerson);
        status2(msg.value);
        if(balances[msg.sender]>(repayAmount[msg.sender])){
        for(uint i =0; i < communityMembers.length; i++){
            address addA=communityMembers[i];
                if (addA==msg.sender){
                status("cant give to yourself");
            }
            else {
                balances[addA]+=repayAmountPerPerson;
                status("given repayment");
            }
        }
        balances[msg.sender]-=repayAmount[msg.sender];
        creditPoints[msg.sender]+=1;
        }
        else {
            status("not enough balance");
        }
    }
    
    function kill() {
        suicide(msg.sender);
    }
    
    
}
