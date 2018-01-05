pragma solidity^0.4.0;

contract ToothFairy {
    
    address child = 0x14723a09acff6d2a60dcdf7aa4aff308;
    address mother = 0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db;
    address toothFairy;
    
    bool toothPaid = false;
    
    enum ToothState {Mouth, WaitingForApproval, Fallen}
    ToothState public toothstate;
    
    function ToothFairy() payable {
        toothFairy = msg.sender;
    }
    
    function toothFall() onlyChild {
        if(toothstate == ToothState.Mouth){
            toothstate = ToothState.WaitingForApproval;
        } else {
            revert();
        }
    }
    
    function motherApproval() onlyMother {
        if(toothstate == ToothState.WaitingForApproval){
            toothstate = ToothState.Fallen;
            payToChild();
            toothPaid = true;
        }
    }
    
    function payToChild() {
        if(toothstate==ToothState.Fallen && toothPaid == false) {
            child.transfer(this.balance);
        }
    }
    
    modifier onlyChild {
        if (msg.sender!=child){
            revert();
        } else {
            _;
        }
    }
    
    modifier onlyMother {
        if (msg.sender!=mother){
            revert();
        } else {
            _;
        }
    }
    
    modifier onlyFairy {
        if (msg.sender!=toothFairy){
            revert();
        } else {
            _;
        }
    }
}