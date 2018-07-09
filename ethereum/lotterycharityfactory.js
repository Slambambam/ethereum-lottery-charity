import web3 from './web3';
import LotteryCharityFactory from './build/LotteryCharityFactory.json';

const instance = new web3.eth.Contract(
  JSON.parse(LotteryCharityFactory.interface),
  LotteryCharityFactory.deploymentAddress
);

export default instance;