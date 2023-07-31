// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

error FundMe_NotOwner();

contract FundMe {
    // Type Declarations
    using PriceConverter for uint256;

    // State variables
    uint256 public constant MINIMUM_USD = 5e18;
    address private immutable i_owner;
    AggregatorV3Interface private s_priceFeed;

    address[] private s_funders;
    mapping(address funder => uint256 amountFunded) private s_addressToAmountFunded;

    // Events (we have none!)

    // Modifiers
    modifier onlyOwner() {
        // require(msg.sender == i_owner, "You are not authorized to call this function.");
        if (msg.sender != i_owner) revert FundMe_NotOwner();
        _;
    }

    // Functions Order:
    //// constructor
    //// receive
    //// fallback
    //// external
    //// public
    //// internal
    //// private
    //// view / pure

    constructor(address priceFeed) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed);
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    function fund() public payable {
        require(msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD, "Not enough ETH!");
        s_funders.push(msg.sender);
        // s_addressToAmountFunded[msg.sender] = s_addressToAmountFunded[msg.sender] + msg.value; Or ====>
        s_addressToAmountFunded[msg.sender] += msg.value;
    }

    function cheaperWithdraw() public onlyOwner {
        uint256 fundersLength = s_funders.length;
        for (uint256 funderIndex = 0; funderIndex < fundersLength; funderIndex++) {}

        s_funders = new address[](0);

        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Withdraw failed");
    }

    function withdraw() public onlyOwner {
        for (uint256 funderIndex = 0; funderIndex < s_funders.length; funderIndex++) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }

        s_funders = new address[](0);

        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Withdraw failed.");
    }

    function getVersion() public view returns (uint256) {
        return s_priceFeed.version();
    }

    /**
     * View/Pure functions (Getters)
     */

    function getAddressToAmountFunded(address fundingAddress) external view returns (uint256) {
        return s_addressToAmountFunded[fundingAddress];
    }

    function getFunderFromFundersArray(uint256 index) external view returns (address) {
        return s_funders[index];
    }

    function getOwner() external view returns (address) {
        return i_owner;
    }
}
