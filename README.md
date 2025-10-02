# Crowdfunding Smart Contract

This is a **Crowdfunding** smart contract built using **Solidity**. It allows a manager to create funding requests, contributors to fund a campaign, and approve spending requests via voting.

---

## **Features**

- Users can contribute to the crowdfunding campaign.  
- Manager can create funding requests.  
- Contributors can vote on spending requests.  
- Refunds are available if the campaign target is not met by the deadline.  
- Funds are released only when majority contributors approve a request.

---

## **Contract Details**

### **State Variables**

- `manager`: Address of the contract deployer (campaign manager).  
- `minimumContribution`: Minimum contribution required (100 wei).  
- `target`: Funding target of the campaign.  
- `deadline`: Timestamp until which contributions are accepted.  
- `raisedAmounts`: Total funds raised.  
- `noOfContributors`: Number of unique contributors.  
- `contributors`: Mapping of contributor address → amount contributed.  
- `requests`: Mapping of request ID → spending request details.  
- `numRequests`: Total number of requests created.

---

### **Structs**

#### **Request**
- `description`: Purpose of the request.  
- `recipient`: Address to receive the funds.  
- `value`: Amount to be transferred.  
- `completed`: Boolean indicating if request is completed.  
- `noOfVoters`: Number of votes for the request.  
- `voters`: Mapping of contributor → voted or not.

---

### **Functions**

1. **constructor(uint _target, uint _deadline)**  
   Initializes the campaign with a funding target and deadline.

2. **createRequest(string calldata _description, address payable _recipient, uint _value)**  
   Only manager can create spending requests.

3. **contribution() payable**  
   Allows users to contribute to the campaign.

4. **getContractBalance() view returns(uint)**  
   Returns current contract balance.

5. **refund()**  
   Allows contributors to get a refund if target not reached after deadline.

6. **voteRequest(uint _requestNo)**  
   Contributors can vote to approve spending requests.

7. **makePayment(uint _requestNo)**  
   Manager can release funds for approved requests if majority supports.

---

## **How to Deploy**

1. Open [Remix IDE](https://remix.ethereum.org/).  
2. Create a new file `Crowdfunding.sol` and paste the contract code.  
3. Compile the contract with Solidity compiler version `^0.8.0`.  
4. Deploy with the required `_target` and `_deadline` values.  

---

## **Usage Example**

```javascript
// Contribute to campaign
crowdFunding.contribution({value: web3.utils.toWei("1", "ether")});

// Manager creates a request
crowdFunding.createRequest("Buy equipment", recipientAddress, web3.utils.toWei("5", "ether"));

// Contributors vote
crowdFunding.voteRequest(0);

// Manager releases payment after majority approval
crowdFunding.makePayment(0);
