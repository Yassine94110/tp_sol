
# SmartBet Contract Project

This Hardhat project demonstrates a comprehensive use case focusing on a betting smart contract named `SmartBet`. The contract allows for user registration, match creation by the admin, placing bets with score predictions, and settling matches to distribute winnings based on accurate predictions. The project includes a sample contract, tests for the contract, and a deployment script. The contract is deployed on the Sepolia testnet.

## Contract Deployment

The SmartBet contract is deployed on the Sepolia testnet at the following address:

- [0x534c9507b059fc144e73ba50284acab1be3ee497](https://sepolia.etherscan.io/address/0x534c9507b059fc144e73ba50284acab1be3ee497)

## Getting Started

To get started with this project, clone the repository and install the dependencies:

```shell
git clone <repository-url>
cd <project-directory>
npm install
```

## Available Tasks

This project uses Hardhat for compilation, testing, and deployment. Here are some common tasks you might find useful:

### Compiling Contracts

Compile the smart contracts with Hardhat:

```shell
npx hardhat compile
```

### Running Tests

Run the tests to ensure the contract behaves as expected:

```shell
npx hardhat test
```

To see detailed gas reports:

```shell
REPORT_GAS=true npx hardhat test
```

### Local Development Node

Start a local Hardhat node:

```shell
npx hardhat node
```

### Deploying to Sepolia Testnet

Deploy the contract to the Sepolia testnet (ensure your `hardhat.config.js` is configured for Sepolia):

```shell
npx hardhat run scripts/deploy.js --network sepolia
```

## Configuration

Before deploying the contract, make sure to configure your `hardhat.config.js` with your Sepolia testnet node URL and private key. This information is crucial for deploying and interacting with contracts on the testnet.

```javascript
require("@nomiclabs/hardhat-waffle");

// Replace 'YOUR_SEPOLIA_NODE_URL' and 'YOUR_PRIVATE_KEY' with your actual Sepolia node URL and private key.
module.exports = {
  solidity: "0.8.0",
  networks: {
    sepolia: {
      url: "YOUR_SEPOLIA_NODE_URL",
      accounts: ['YOUR_PRIVATE_KEY']
    }
  }
};
```

## Interacting with the Contract

After deploying, you can interact with the contract on the Sepolia testnet using Hardhat or Ethers.js by connecting to the deployed contract address.

## Contributions

Contributions are welcome! Please feel free to submit issues or pull requests with improvements or new features.

