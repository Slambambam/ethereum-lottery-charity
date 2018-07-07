import web3 from './web3';
import LotteryCharity from './build/LotteryCharity.json';

export default (address) => {
  return new web3.eth.Contract(
    JSON.parse(LotteryCharity.interface),
    address
  );
};