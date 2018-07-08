pragma solidity ^0.4.24;

import "./LotteryCharity.sol";
import "./LotteryCharityEscrow.sol";

contract LotteryCharityFactory {
    address public overseer;
    address private deployedEscrow;
    address[] private deployedLotteries;
    
    
    modifier restricted() {
        require(msg.sender == overseer);
        _;
    }
    
    modifier escrowExists() {
        require(deployedEscrow != 0);
        _;
    }
    
    constructor(address creator) public {
        overseer = creator;
        deployedEscrow = new LotteryCharityEscrow(creator);
    }
    
    function addCharityCategory(string name) public restricted {
        LotteryCharityEscrow escrow = LotteryCharityEscrow(deployedEscrow);
        escrow.addCharityCategory(name);
    }
    
    function getDeployedLotteries() public view returns(address[]) {
        return deployedLotteries;
    }
    
    function getDeployedEscrow() public view returns(address) {
        return deployedEscrow;
    }
    
    function createLottery(string name, string description, uint ticketPrice, uint minCharitablePercentage, uint blockHeightTimeLimit) public escrowExists {
        address lottery = new LotteryCharity(msg.sender, name, description, ticketPrice, minCharitablePercentage, blockHeightTimeLimit);
        deployedLotteries.push(lottery);
    }
}

