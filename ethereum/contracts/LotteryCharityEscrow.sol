pragma solidity ^0.4.24;

contract LotteryCharityEscrow {
    struct CharitableFundingRequest {
        uint amount;                         // Amount of ether (wei)
        string organization;                 // Name of charity
        string reason;                       // Reason or claim to funds
        string registrationId;               // EIN or Registration Number
        string contactName;                  // Name of contact in charity
        string email;                        // Email address
        string phoneNumber;                  // Contact number
        address charityAddress;              // Payee/person/organization receiving funds
        uint charityCategoryIndex;           // Array index of the charity category to draw funding from
        bool approved;                       // Has the money been sent
        bool denied;                         // Request has been turned down due to verification or other reasons
    }

    struct CharityCategory {
        string name;
        uint funds;
    }
    
    address public overseer;
    uint private totalBalance;
    CharityCategory[] private charityCategories;
    CharitableFundingRequest[] private charitableFundingRequests;
    
    modifier restricted() {
        require(msg.sender == overseer);
        _;
    }
    
    constructor(address creator) public {
        overseer = creator;
    }
    
    function addCharityCategory(string name) public restricted {
        CharityCategory memory category = CharityCategory({
            name: name,
            funds: 0
        });
        charityCategories.push(category);
    }
    
    function getCharityCategoriesLength() public view returns (uint) {
        return charityCategories.length;
    }
    
    function getCharityCategoryName(uint index) public view returns (string) {
        return charityCategories[index].name;
    }

    function getCharityCategoryFunds(uint index) public view returns (uint) {
        return charityCategories[index].funds;
    }
    
    function createCharitableFundingRequest(
        uint amount, string organizationName, string fundingReason, string registrationId,
        string contactName, string email, string phoneNumber, uint charityCategoryIndex) public {
        CharitableFundingRequest memory request = CharitableFundingRequest({
            amount: amount,
            organization: organizationName,
            reason: fundingReason,
            registrationId: registrationId,
            contactName: contactName,
            email: email,
            phoneNumber: phoneNumber,
            charityAddress: msg.sender,
            charityCategoryIndex: charityCategoryIndex,
            approved: false,
            denied: false
        });
        charitableFundingRequests.push(request);
    }
    
    function approveCharitableFundingRequest(uint index) public restricted {
        require(request.amount <= address(this).balance);
        require(totalBalance == address(this).balance);
        
        CharitableFundingRequest storage request = charitableFundingRequests[index];
        require(!request.approved);
        require(!request.denied);

        totalBalance = totalBalance - request.amount;

        request.charityAddress.transfer(request.amount);
        request.approved = true;
    }
    
    function denyCharitableFundingRequest(uint index) public restricted {
        CharitableFundingRequest storage request = charitableFundingRequests[index];
        
        require(!request.approved);
        require(!request.denied);

        request.denied = true;
    }
    
    function allocateCharitableFunds(uint index) public payable {
        require(totalBalance == address(this).balance);
        totalBalance = totalBalance + msg.value;
        
        CharityCategory storage charityCategory = charityCategories[index];
        charityCategory.funds = charityCategory.funds + msg.value;
    }
    
}