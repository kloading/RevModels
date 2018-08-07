pragma solidity ^0.4.0;
contract subscription {
    
    User public userInfo;
    address public appOwner = 0xac4013A20D0FDb5908673CBCD4d400e3DC68726b;
    struct User {        
       address userAddr;      
       Subscription subInfo;  
       bytes current;        
       bytes previous;        
    }
    
    struct Subscription {
        bool status;
        uint expiry;
    }
    
    modifier userOnly()
    {
        if(msg.sender != userInfo.userAddr) { revert(); }
        else _;
    }
    
    modifier appOwnerOnly()
    {
        if(msg.sender != appOwner) { revert(); }
        else _;
    }
    
    constructor() public 
    {
        userInfo = User({userAddr: msg.sender, subInfo: Subscription({ status: false, expiry: block.timestamp }) });
    }
    
    //Subscribe for 1 month. Costs 1 ETH + gas
    function subscribe() public userOnly payable 
    {
        require(msg.value == 1 ether); //if not met, function will throw and return money minus gas
        userInfo.subInfo.status = true;
        userInfo.subInfo.expiry = block.timestamp + 30 days;
        appOwner.transfer(1 ether);
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
    
    function rewind() public userOnly returns(bool success)
    {
        if(checkSubscription() != true) {
            return false;
        } else {
            userInfo.current = previous; //rewinding swipe
            userInfo.previous = "";        
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
