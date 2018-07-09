const assert = require('assert');
const ganache = require('ganache-cli');
const Web3 = require('web3');
const provider = ganache.provider();
const web3 = new Web3(provider);

const compiledFactory = require('../ethereum/build/LotteryCharityFactory.json');
const compiledLotteryCharityEscrow = require('../ethereum/build/LotteryCharityEscrow.json');
const compiledLotteryCharity = require('../ethereum/build/LotteryCharity.json');

let accounts;
let factory;
let lotteryCharityAddress;
let lotteryCharity;
let lotteryCharityEscrowAddress;
let lotteryCharityEscrow;

beforeEach(async () => {
  // Get a list of all accounts
  accounts = await web3.eth.getAccounts();

  // Use one of those accounts to deploy the contract
  factory = await new web3.eth.Contract(JSON.parse(compiledFactory.interface))
    .deploy({ data: compiledFactory.bytecode })
    .send({ from: accounts[0], gas: '3000000' });

  factory.setProvider(provider);

  await factory.methods.addCharityCategory('test_category1').send({
    from: accounts[0],
    gas: '3000000'
  });

  await factory.methods.addCharityCategory('test_category2').send({
    from: accounts[0],
    gas: '3000000'
  });

  await factory.methods.createLottery('test', 'test', 50000000000000000, 20, 5, 5, 5).send({
    from: accounts[0],
    gas: '3000000'
  });

  [lotteryCharityAddress] = await factory.methods.getDeployedLotteries().call();

  lotteryCharity = await new web3.eth.Contract(
    JSON.parse(compiledLotteryCharity.interface),
    lotteryCharityAddress
  );

  lotteryCharityEscrowAddress = await factory.methods.getDeployedEscrowAddress().call();

  lotteryCharityEscrow = await new web3.eth.Contract(
    JSON.parse(compiledLotteryCharityEscrow.interface),
    lotteryCharityEscrowAddress
  );

});

describe('Deployment', () => {
  it('deploys a factory, lotteryCharityEscrow, and lotteryCharity', () => {
    assert.ok(lotteryCharityEscrow.options.address);
    assert.ok(lotteryCharity.options.address);
    assert.ok(factory.options.address);
  });
});
