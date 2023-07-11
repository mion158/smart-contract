pragma solidity ^0.4.17;

import "remix_tests.sol"; // Import the Remix testing library
import "../contracts/Auction.sol";

contract AuctionContractTest {
    Auction auctionInstance;
    
    function beforeAll() public {
        auctionInstance = new Auction();
    }
    
    function testContractDeployment() public {
        Assert.notEqual(address(auctionInstance), address(0), "Auction contract should be deployed");
    }
    
    function testRegistration() public {
        uint remainingTokens = auctionInstance.getPersonDetails(0)[0];
        uint personId = auctionInstance.getPersonDetails(0)[1];
        address bidderAddress = auctionInstance.getPersonDetails(0)[2];
        
        Assert.equal(remainingTokens, 5, "Remaining tokens should be initialized to 5");
        Assert.equal(personId, 0, "Person ID should be 0");
        Assert.equal(bidderAddress, address(this), "Bidder address should be the test contract's address");
    }
    
    function testBidding() public {
        uint itemId = 0;
        uint count = 3;
        
        auctionInstance.bid.value(count)(itemId, count);
        
        uint remainingTokens = auctionInstance.getPersonDetails(0)[0];
        uint[] memory itemTokens = auctionInstance.items(itemId).itemTokens;
        
        Assert.equal(remainingTokens, 2, "Remaining tokens should be decreased");
        Assert.equal(itemTokens.length, count, "Item tokens array should have correct length");
        Assert.equal(itemTokens[count - 1], 0, "Last element of item tokens array should match person ID");
    }
    
    function testRevealWinners() public {
        auctionInstance.revealWinners();
        
        address winner1 = auctionInstance.winners(0);
        address winner2 = auctionInstance.winners(1);
        address winner3 = auctionInstance.winners(2);
        
        Assert.notEqual(winner1, address(0), "Winner address should not be zero");
        Assert.notEqual(winner2, address(0), "Winner address should not be zero");
        Assert.notEqual(winner3, address(0), "Winner address should not be zero");
    }
    
    function runTests() public {
        beforeAll();
        testContractDeployment();
        testRegistration();
        testBidding();
        testRevealWinners();
    }
}
