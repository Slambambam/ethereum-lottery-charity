const HDWalletProvider = require('truffle-hdwallet-provider');
const Web3 = require('web3');
const path = require('path');
const fs = require('fs-extra');

const config = require('./config.json');

const provider = new HDWalletProvider(
  config.provider.mnemonic,
  config.provider.url + config.provider.token
);

const compiledFactoryPath = './build/LotteryCharityFactory.json';
const compiledFactory = require('./build/LotteryCharityFactory.json');

const web3 = new Web3(provider);

const deploy = async () => {
  // Get a list of all accounts
  const accounts = await web3.eth.getAccounts();

  console.log('Attempting to deploy from account', accounts[0]);

  // Use one of those accounts to deploy the contract
  const result = await new web3.eth.Contract(JSON.parse(compiledFactory.interface))
    .deploy({ data: compiledFactory.bytecode })
    .send({ from: accounts[0], gas: '1000000' });

  // Add deploymentAddress to contract JSON file
  var data = compiledFactory;
  data['deploymentAddress'] = result.options.address;
  fs.outputJsonSync(path.resolve(compiledFactoryPath), data, function (err) {
    if (err) {
      return console.log(err);
    }
  });

  console.log('Contract deployed to', result.options.address);
};
deploy();
