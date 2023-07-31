# FundMe Solidity App

This is a README file for the FundMe Solidity app. The app allows users to fund the contract with Ether and keeps track of the amount funded by each user.

## Table of Contents

- [FundMe Solidity App](#fundme-solidity-app)
  - [Table of Contents](#table-of-contents)
  - [Contract Details](#contract-details)
  - [Usage](#usage)
  - [Functions](#functions)
    - [receive](#receive)
    - [fallback](#fallback)
    - [cheaperWithdraw](#cheaperwithdraw)
  - [View/Pure Functions](#viewpure-functions)
    - [getVersion](#getversion)
    - [getAddressToAmountFunded](#getaddresstoamountfunded)
    - [getFunderFromFundersArray](#getfunderfromfundersarray)
    - [getOwner](#getowner)
  - [License](#license)

## Contract Details

The FundMe contract is implemented in Solidity version 0.8.18. It utilizes the Chainlink AggregatorV3Interface to get the price feed for Ether. The minimum amount of Ether required to fund is set to 5 ETH.

## Usage

To use the FundMe contract, you need to deploy it on the Ethereum network. The constructor takes an address parameter for the price feed contract.

```solidity
constructor(address priceFeed)
```

Once deployed, users can fund the contract by sending Ether to it. The fund function is used for this purpose.

```solidity
function fund() public payable
```

The contract owner can withdraw the funds by calling the withdraw function.

```solidity
function withdraw() public onlyOwner
```

## Functions

### receive

The receive function is a fallback function that allows users to fund the contract by simply sending Ether to it.

```solidity
receive() external payable
```

### fallback

The fallback function is another fallback function that allows users to fund the contract by sending Ether to it.

```solidity
fallback() external payable
```

### cheaperWithdraw

The cheaperWithdraw function allows the contract owner to withdraw funds from the contract. It redistributes the funds among the funders based on a cheaper algorithm.

```solidity
function cheaperWithdraw() public onlyOwner
```

## View/Pure Functions

### getVersion

The getVersion function returns the version of the price feed contract.

```solidity
function getVersion() public view returns (uint256)
```

### getAddressToAmountFunded

The getAddressToAmountFunded function returns the amount funded by a specific address.

```solidity
function getAddressToAmountFunded(address fundingAddress) external view returns (uint256)
```

### getFunderFromFundersArray

The getFunderFromFundersArray function returns the funder's address at a specific index in the funders array.

```solidity
function getFunderFromFundersArray(uint256 index) external view returns (address)
```

### getOwner

The getOwner function returns the address of the contract owner.

```solidity
function getOwner() external view returns (address)
```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.