pragma solidity ^0.4.24;

import "./LotteryCharityEscrow.sol";
import "./SafeMath.sol";

contract LotteryCharity {

    using SafeMath for uint;
    
    address public lotteryManager;
    string public name;
    string public description;
    uint public ticketPrice;
    uint public minCharitablePercentage;
    uint public blockHeightBuyingPeriod;
    uint public blockHeightVerifyPeriod;
    uint public blockHeightClaimPeriod;
    uint public blockHeightStartTime;
    address public charityEscrowAddress;
    LotteryCharityEscrow escrowInstance;

    address[] public _entries;
    address[] public _verified;
    uint private entriesTotal;
    uint private verifiedTotal;
    uint private forfeitureTotal;
    mapping(address => uint) public _tickets;
    uint private winnerSeed;
    bool private hasWinner;
    address private winner;
    mapping(address => uint) private _winnings;     

    constructor(address _manager, address _escrow, string _name, string _description, uint _ticketPrice, uint _minCharitablePercentage,
    uint _blockHeightBuyingPeriod, uint _blockHeightVerifyPeriod, uint _blockHeightClaimPeriod) public {
        require(_escrow != address(0));
        require(_minCharitablePercentage >= 10 && _minCharitablePercentage <= 90);

        charityEscrowAddress = _escrow;
        lotteryManager = _manager;
        name = _name;
        description = _description;
        ticketPrice = _ticketPrice;
        minCharitablePercentage = _minCharitablePercentage;
        blockHeightBuyingPeriod = _blockHeightBuyingPeriod;
        blockHeightVerifyPeriod = _blockHeightVerifyPeriod;
        blockHeightClaimPeriod = _blockHeightClaimPeriod;
        blockHeightStartTime = block.number;
        escrowInstance = LotteryCharityEscrow(charityEscrowAddress);
    }
    
    function getCurrentBlockHeight() public view returns (uint) {
        return block.number;
    }

    function getCharityCategory(uint index) public view returns (string) {
        require(index < escrowInstance.getCharityCategoriesLength());
        return escrowInstance.getCharityCategoryName(index);
    }
    
    function buyTicket(uint hash, uint charityIndex) payable public returns (bool) {
        require(block.number < blockHeightStartTime + blockHeightBuyingPeriod);
        require(msg.value == ticketPrice);
        require(_tickets[msg.sender] == 0);
        require(charityIndex < escrowInstance.getCharityCategoriesLength());

        _tickets[msg.sender] = hash;
        _entries.push(msg.sender);

        uint charitableCut = ticketPrice.div(100).mul(minCharitablePercentage);
        entriesTotal += ticketPrice - charitableCut;
        escrowInstance.allocateCharitableFunds.value(charitableCut)(charityIndex);

        return true;
    }

    function generateHash(uint number, uint salt) external pure returns(uint) {
        return uint(keccak256(abi.encodePacked(number, salt)));
    }

    function verifyTicket(uint number, uint salt) public returns (bool) {
        require(block.number >= blockHeightStartTime + blockHeightBuyingPeriod);
        require(block.number < blockHeightStartTime + blockHeightBuyingPeriod + blockHeightVerifyPeriod);
        require(_tickets[msg.sender] > 0);
        require(this.generateHash(number, salt) == _tickets[msg.sender]);
        require(salt > number);

        winnerSeed = winnerSeed ^ uint256(msg.sender) ^ salt;
        _verified.push(msg.sender);
        verifiedTotal += ticketPrice;

        return true;
    }

    function selectWinner() public returns (bool) {
        require(block.number >= blockHeightStartTime + blockHeightBuyingPeriod + blockHeightVerifyPeriod);
        require(block.number < blockHeightStartTime + blockHeightBuyingPeriod + blockHeightVerifyPeriod + blockHeightClaimPeriod);

        if (!hasWinner) {
            winner = _verified[winnerSeed % _verified.length];
            _winnings[winner] = verifiedTotal;
            forfeitureTotal = entriesTotal - verifiedTotal;
            // Allocate forfeited funds to a random charity category
            escrowInstance.allocateCharitableFunds.value(forfeitureTotal)(winnerSeed % escrowInstance.getCharityCategoriesLength());
            hasWinner = true;
        }
        return msg.sender == winner;
    }

    function claimWinnings() public {
        require(_winnings[msg.sender] > 0);
        require(hasWinner);

        msg.sender.transfer(_winnings[msg.sender]);
        _winnings[msg.sender] = 0;
    }
}