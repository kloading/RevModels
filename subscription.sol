pragma solidity ^0.4.0;
contract subscription {
    
    User public userInfo;

    struct User {
        address userAddr;
        Subscription subInfo;
    }
    
    struct Subscription {
        bool status;
        uint expiry;
    }
    
    modifier ownerOnly()
    {
        if(msg.sender != userInfo.userAddr) { revert(); }
        else _;
    }
    
    constructor() public 
    {
        userInfo = User({userAddr: msg.sender, subInfo: Subscription({ status: false, expiry: block.timestamp }) });
    }
    
    //Subscribe for 1 month. Costs 1 ETH
    function subscribe() public ownerOnly payable 
    {
        require(msg.value == 1 ether); //if not met, function will throw and return money minus gas
        userInfo.subInfo.status = true;
        userInfo.subInfo.expiry = block.timestamp + 30 days;
    }
    
    //Function used internally to evaluate subscriptions status (can make a state change)
    function checkSubscription() internal returns(bool status)
    {
        if(userInfo.subInfo.status != true) {
            return false;
        }
        if (block.timestamp >= userInfo.subInfo.expiry) {
            userInfo.subInfo.status = false;
            return false;
        } else {
            return true;
        }
    }
    
    function rewind() public ownerOnly returns(bool success)
    {
        if(checkSubscription() != true) {
            return false;
        } else {
            //Show previous card
            return true;
        }
    }
    
    //Free way for front-ends to check subscription to avoid calls that waste gas
    function peekSubscription() public constant returns(bool status) 
    {
        if(userInfo.subInfo.status != true || block.timestamp >= userInfo.subInfo.expiry) {
            return false;
        } else {
            return true;
        }
    }
    
}
