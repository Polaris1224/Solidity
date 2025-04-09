// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18 ;

//We moved this import to PriceConverter.sol....
// import { AggregatorV3Interface } from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol" ;
//Now lets import the library
import { PriceConverter } from "./PriceConverter.sol" ;

//Want this contract to accept some type of payment
contract FundMe {

    //Setting up library for uint256...
    using PriceConverter for uint256 ;

    uint256 public minimumUsd = 5e18 ;
    //This mapping will store the people how send funds and how much funds...
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded ;
    address[] public funders ;


    address public owner ;
    // In constructor we will set up the address of the owner right when the contract is deployed as constructor works
    // immediately when the contract is deployed...

    constructor() {
        // msg.sender => is the sender of the caller of the contract (deployer of the contract)...
        owner = msg.sender ;
    }

    function fund() public payable {

        // getConversionRate(msg.value) -> This doesnt work with library
        // To pass parameter we have to do msg.value.getConversionRate()
        //This function is not from PriceConverter Library so we cant call it directly
        //In this case its gonna return the price of USD
        //msg.value.getConversionRate() 
        //Here msg.value will be the 1st parameter to be passed in getConversionRate...
        //In case of 2nd parameter we have to pass it inside msg.value.getConversionRate(2nd parameter)...
        require(msg.value.getConversionRate() >= minimumUsd, "didn't send enough ETH") ;
        addressToAmountFunded[msg.sender] = addressToAmountFunded[msg.sender] + msg.value ;
        //Here msg.sender and msg.value are global variables and can be used  (docs.soliditylang.com...)
    }

    // We want to withdraw the amount that we collect in the contract...
    // We also want that only the owner of the contract should withdraw the amount...
    // No one else must be allowed to withdraw the money...
    // After reading this check constructor...
    // Here onlyOwner is modifier declared just after this function for checking that this function is called by an owner or not...
    function withdraw() public onlyOwner {
        //If withdraw function is not called by the owner then msg will be passed "Must be owner"...
        
        // for loop
        for(uint256 funderIndex = 0 ; funderIndex < funders.length ; funderIndex++) {
            address funder = funders[funderIndex] ;
            addressToAmountFunded[funder] = 0 ;
        }    
        //To reset the funders array...
        funders = new address[](0) ;
        
        // actually withdraw the funds

        // transfer()
        // msg.sender = address
        // payable(msg.sender) = payable address
        payable(msg.sender).transfer(address(this).balance) ;
        // transfer(2300 gas, throw error)
        // If gas amount is more than 2300 then it throws error and transfer is automatically reverted...

        // send()
        bool sendSuccess = payable(msg.sender).send(address(this).balance) ;
        require(sendSuccess, "Send failed") ;
        //If(2300 gas, return bool)
        //If gas amount is more than 2300 than it returns boolean...

        //call (One of the lower level most powerful function)
        // Used to call virtually any function in all the ethereum without even need of ABI
        (bool callSuccess, bytes memory dataReturned) = payable(msg.sender).call{value: address(this).balance}("") ;
        require(callSuccess, "Call failed") ;
        // callSuccess means call had be successfully made...
        // dataReturned means the data returned by the function...
        // bytes objects are array so they needs to be returned in the memory...
        // This means: If callSuccess is **true** → the require passes → nothing happens, and the code continues.
        // If callSuccess is **false** → the require fails → transaction reverts with message "Call failed".

        //call is the most recommended way for transaction...
    }

    //Modifiers in Blockchains
    modifier onlyOwner() {
        require(msg.sender == owner, "Must be owner!") ;
        _;
        // Here require keyword works and we check whether owner called it or not...
        // "_" underscore tells that now execute rest of the function...
        // Here position of "_" matters...
    }
}