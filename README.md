# Ethereum Charity Lottery
A platform to create ethereum lotteries where a set portion of the proceeds go to a charities verified by an overseer.

## Install Node Modules
`npm install`

## Compile Contracts
First you must create a `config.json` file in the ethereum directory with the following structure:
```javascript
{
  "contracts": {
    "input": "contracts",
    "output": "build",
    "files": [
      "LotteryCharityEscrow.sol",
      "LotteryCharityFactory.sol",
      "LotteryCharity.sol"
    ]
  },
  "provider": {
    "url": "https://rinkeby.infura.io/",
    "token": "1234567abcde",
    "mnemonic": "zoo leader seminar raven alien gain faculty wall age relief spot elegant"
  }
}
```
In this project I opted to use infura as my network provider via Web3.

DO NOT commit the config.json file to github with your live mnemonic or API token. config.json has been added to .gitignore in this project.

In the ethereum directory, run:
`node compile.js`

## Run Mocha Tests
Run the mocha tests against the smart contracts (on the Ganache local test network):
`npm test`

## Deploy Contract To Rinkeby Test Network
In the ethereum directory, run:
`node deploy.js`

Note down the output address that the contract has been deployed to. You can look  up the contract by entering the address on `https://rinkeby.etherscan.io/`

If you are not deploying from within the ethereum folder, the build output will be in the wrong location and the deploymentAddress property will not be added to LotteryCharityFactory.json output. This will cause the application to throw a 'contract address not found' error.

## Run The Web Application
`npm start`
