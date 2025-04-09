// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import { AggregatorV3Interface } from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol" ;

//Library is similar to contracts, but you can't declare any state variable and you can't send ether.
//Library is embedded into the contract if all library functions are internal.
// Otherwise the library must be deployed and then linked before the contract is deployed.
//Check documentation of library in Solidity docs...
library PriceConverter {
    //To get the price of USD
    function getPrice() internal view returns(uint256) { 
        //In Chainlink documentation
        //See code part get the address like : 0x1b44F35148........... , this is the address of contract having the updated price
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
    function getConversionRate(uint256 ethAmount) internal view returns(uint256) {
        //You can go through AI to understand the maths
        uint256 ethPrice = getPrice() ;
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18 ;
        return ethAmountInUsd ;
    }

    function getVersion() internal view returns (uint256) {
        return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version() ;
    }

}