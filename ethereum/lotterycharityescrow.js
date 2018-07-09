import web3 from './web3';
import LotteryCharityEscrow from './build/LotteryCharityEscrow.json';

export default (address) => {
  return new web3.eth.Contract(
    JSON.parse(LotteryCharityEscrow.interface),
    address
  );
};