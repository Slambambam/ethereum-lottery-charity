pragma solidity ^0.4.24;

contract LotteryCharity {
    
    address public lotteryManager;
    string public name;
    string public description;
    uint public ticketPrice;
    uint public minCharitablePercentage;
    uint public blockHeightTimeLimit;
    uint public blockHeightStartTime;
    address[] public tickets;
    

    constructor(address _manager, string _name, string _description, uint _ticketPrice, uint _minCharitablePercentage, uint _blockHeightTimeLimit) public {
        lotteryManager = _manager;
        name = _name;
        description = _description;
        ticketPrice = _ticketPrice;
        minCharitablePercentage = _minCharitablePercentage;
        blockHeightTimeLimit = _blockHeightTimeLimit;
        blockHeightStartTime = block.number;
    }
    
    function buyTicket() payable public {
        require(msg.value >= ticketPrice);
        tickets.push(msg.sender);
    }
}