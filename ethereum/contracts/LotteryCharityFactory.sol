pragma solidity ^0.4.24;

import "./LotteryCharity.sol";
import "./LotteryCharityEscrow.sol";

contract LotteryCharityFactory {
    address public overseer;
    address private deployedEscrowAddress;
    address[] private deployedLotteries;
    LotteryCharityEscrow escrowInstance;
    
    
    modifier restricted() {
        require(msg.sender == overseer);
        _;
    }
    
    modifier escrowExists() {
        require(deployedEscrowAddress != address(0));
        _;
    }

    modifier charityCategoriesExist() {
        require(escrowInstance.getCharityCategoriesLength() > 0);
        _;
    }
    
    constructor() public {
        overseer = msg.sender;
        deployedEscrowAddress = new LotteryCharityEscrow(overseer);
        escrowInstance = LotteryCharityEscrow(deployedEscrowAddress);
    }
    
    function addCharityCategory(string name) public restricted escrowExists {
        escrowInstance.addCharityCategory(name);
    }
    
    function getDeployedLotteries() public view returns(address[]) {
        return deployedLotteries;
    }
    
    function getDeployedEscrowAddress() public view returns(address) {
        return deployedEscrowAddress;
    }
    
    function createLottery(
        string name, string description, uint ticketPrice, uint minCharitablePercentage,
        uint blockHeightBuyingPeriod, uint blockHeightVerifyPeriod, uint blockHeightClaimPeriod)
    public escrowExists charityCategoriesExist returns (address) {
        address lottery = new LotteryCharity(msg.sender, deployedEscrowAddress, name, description, ticketPrice, minCharitablePercentage,
        blockHeightBuyingPeriod, blockHeightVerifyPeriod, blockHeightClaimPeriod);
        deployedLotteries.push(lottery);
        return lottery;
    }
}

