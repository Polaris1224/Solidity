// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18 ;

import { AggregatorV3Interface } from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol" ;

//Want this contract to accept some type of payment
contract FundMe {

    uint256 public minimumUsd = 5e18 ;
    //This mapping will store the people how send funds and how much funds...
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded ;

    //Function through which other provide us money
    //"payable" : we define this function payable, which tells that using this function we can pay for things (Specifically, payable with ETH/Ethereum)
    //Wei, Gwei  n Ether are just the different way of sending ether...
    function fund() public payable {

        //require(msg.value > 1e18, "didn't send enough ETH") ;
        //This check whether we revieve 1ETH (1e18 GWei), if not then it revert the transaction.
        //Deploy this and then in value section of above Deploy button add 2 ETH and click fund button and transaction occur
        //What is revert ?
        //Undo any action that have been done, and send remaining gas back ... Each and every change is reverted.
        //We have to spend some gas for reverting the transaction
        //Each transaction has these fields : Nonce, Gas Price, Gas Limit, To, Value, Data, (v, r, s)

        require(getConversionRate(msg.value) >= minimumUsd, "didn't send enough ETH") ;
        addressToAmountFunded[msg.sender] = addressToAmountFunded[msg.sender] + msg.value ;
        //Here msg.sender and msg.value are global variables and can be used  (docs.soliditylang.com...)

        //Here, msg,value is in ETH, minimumUsd is in dollars...
        //What is ETH -> USD conversion rate
        //For getting this data (ORACLE PROBLEM IN BLOCKCHAIN)
        //Blockchain is deterministic systems and oracle is a bridge between blockchain and real world...
        //We cannot call random function or make a api_call from block of blockchain as 
        //random : each block calls random function and get a random value means there are irregularities between values of each block...
        //api_calls : if different blocks calls api at different time, each block will get different info and there are chances that api is depricated or hacked even
        //another reasons for api_calls may leads blockchain to make assumption of real world based on political/geo-political issues...

        //Centralized Oracle are Points of Failure : as blockchain itself is a decentralised system and using centralised oracle ruins its decentralized nature...
        //Means we need some sort of decentralized network for data (Chain Link)
        //Chain Link : Decentralized is modular decentralized oralce network that allow us to get data and do external computation in a decentralized manner. It is customisable as we want...
        //Having a decentralized network brings data on chain and have a reference point of definitive truth allows users to all colobrate and use this common good which makes it cheaper, more secure and more efficient for everybody even running for centralized oravcle...
        //Chainlink supports the growth of the DeFi Ecosystem...
        //Examples : Synthetix, SushiSwap, Set Protocol and AAVE...
        //We can also make chain-link API calls and make our own decentralized system...(One can go through its documentation)
        //data.chain.link (website)
        
        //Oracle network (Chain Link) brings off chain data 
        //Chain Link is modular decentralised Oracle Network that can be customised to get any data and do any computation.
        //Here is Hybrid Smart Contracts which combines on chain and off chain to create feature rich powerful application.
        //Chainlink Data Feeds: 
        //1.Get data from different exchanges and data providers
        //2.Pass this data to the decentralized chain link nodes to get the actual price of the asset
        //3.Then diliver through single transaction to the Reference Contract / data contract onchain, through which other smart contract can use...
        //Whenever node operator dilivers data to smart contract chainlink node operator are pair oracle gas in chain link token.


        //Chainlink VRF
        //Chainlink Keeper : Chainlink Keepers is a decentralized automation service that enables smart contracts to perform predefined tasks without manual intervention. By utilizing a network of off-chain nodes, known as Keepers, it monitors blockchain conditions and triggers smart contract functions when specified criteria are met. 
        //Chainlink Functions

    }

    //To get the price of USD
    function getPrice() public view returns(uint256) { 
        //In Chainlink documentation
        //See code part get the address like : 0x1b44F35148..........., this is the address of contract having the updated price
        //To reach out the contract we need 2 things: Address and ABI
        //Go to price feed address find the ETH/USD and copy the address in sepolia testnet. Currently -> 0x694AA1769357215DE4FAC081bf1f309aDC325306 please check the latest
        //ABI: In Java, you use an interface to define what methods a class should have.

        //In Solidity, the ABI defines what functions/events a contract has and how to talk to it.
        //But instead of code-level enforcement like in OOP, the ABI helps external apps or other smart contracts understand:
        //What function names exist
        //What parameters are required
        //What data types are involved
        //What the function will return
        //Whether the function modifies state (or not)
        //Look at the github import at the top, thats an ABI

        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306) ;
        //This is from documentation : Using Data Feeds on EVM Chains
        (uint80 roundId, int256 price, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound) = priceFeed.latestRoundData() ;
        //This data we get is dont have decimal, we have a decimal function to know about it
        // 1ETH = 1e18 Wei
        //So price has 8 decimal 
        //And msg.value has 18 decimal
        //Now as price is int and msg.value is uint256. Type cast
        return uint256(price * 1e10) ;
    }

    //For conversion of USD and ETH
    function getConversionRate(uint256 ethAmount) public view returns(uint256) {
        //You can go through AI to understand the maths
        uint256 ethPrice = getPrice() ;
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18 ;
        return ethAmountInUsd ;
    }

    // function withdraw() public {

    // }
}