const routes = require('next-routes')();

routes
  .add('/lotteries/new', '/lotteries/new')
  .add('/lotteries/:address', '/lotteries/show')
  .add('/lotteries/:address/requests', '/lotteries/requests/index')
  .add('/lotteries/:address/requests/new', '/lotteries/requests/new');

module.exports = routes;