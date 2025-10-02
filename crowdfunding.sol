// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract CrowdFunding {

    struct Request {
        string description;
        address payable recipient;
        uint value;
        bool completed;
        uint noOfVoters;
        mapping(address => bool) voters;
    }

    mapping(address => uint) public contributors;
    mapping(uint => Request) public requests; // fixed
    uint public numRequests;

    address public manager;
    uint public minimumContribution;
    uint public deadline;
    uint public target;
    uint public raisedAmounts;
    uint public noOfContributors;

    constructor(uint _target, uint _deadline) {
        target = _target;
        deadline = block.timestamp + _deadline;
        minimumContribution = 100 wei;
        manager = msg.sender;
    }

    modifier onlyManager() {
        require(msg.sender == manager, "You are not the manager");
        _;
    }

    function createRequest(string calldata _description, address payable _recipient, uint _value) public onlyManager {
        Request storage newRequest = requests[numRequests];
        newRequest.description = _description;
        newRequest.recipient = _recipient;
        newRequest.value = _value;
        newRequest.completed = false;
        newRequest.noOfVoters = 0;
        numRequests++;
    } 

    function contribution() public payable{
        require(block.timestamp<deadline , "Deadline has passed"); 
        require(msg.value>=minimumContribution , "Minimum contribution is 100 wei");

        if(contributors[msg.sender]==0){
            noOfContributors++; 
        } 
        contributors[msg.sender]+=msg.value; 
        raisedAmounts+=msg.value; 
    }

    function getContractBalance() public view returns(uint){
        return address(this).balance; 
    } 
     
     function refund() public{
        require(block.timestamp>deadline && raisedAmounts<target, "You are not eligible for refund");
         require(contributors[msg.sender]>0, "You are not a  contributors"); 
         payable(msg.sender).transfer(contributors[msg.sender]);
         contributors[msg.sender]= 0 ; 
     } 


     function voteRequest(uint _requestNo) public{
        require(contributors[msg.sender]>0 , "You are not eligible to vote"); 
        Request storage thisRequest = requests[_requestNo]; 
        require(thisRequest.voters[msg.sender]==false , "You are already voted"); 
        thisRequest.voters[msg.sender]= true; 
        thisRequest.noOfVoters++; 
     }

    function makePayment(uint _requestNo) public onlyManager{
        require(raisedAmounts>=target , "Target is not required"); 
        Request storage thisRequest=requests[_requestNo]; 
        require(thisRequest.completed==false, "The request has been completed"); 
        require(thisRequest.noOfVoters>noOfContributors/2,"Majority does not support the request"); 
        thisRequest.recipient.transfer(thisRequest.value); 
        thisRequest.completed= true; 
    }

}
