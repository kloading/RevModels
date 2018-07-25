pragma solidity ^0.4.0;
contract adspace {
    
    Ad public current;
    
    struct Ad {
        string hash;
        uint bid;
        address creator;
    }
    
    constructor() public 
    {
        //do nothing
    }
    
    //Subscribe for 1 month. Costs 1 ETH
    function bid(string locHash) public payable 
    {
        if(current.creator > 0) {
            //there is a current ad
            //so check if bid is greater than current bid
            require(msg.value > current.bid); 
            current = Ad({hash: locHash, bid: msg.value, creator: msg.sender});
        } else {
            //there is no current ad
            current = Ad({hash: locHash, bid: msg.value, creator: msg.sender});
        }
    }
    
}
