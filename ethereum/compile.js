const path = require('path');
const fs = require('fs-extra');
const solc = require('solc');
const config = require('./config.json');

const buildPath = path.resolve(__dirname, config.contracts.output);
fs.removeSync(buildPath);

let contractPath;
let sources = {};
let output;

for (let fileIndex in config.contracts.files) {
  contractPath = path.resolve(__dirname, config.contracts.input, config.contracts.files[fileIndex]);
  sources[config.contracts.files[fileIndex]] = fs.readFileSync(contractPath, 'utf8');
}

output = solc.compile({ sources }, 1).contracts;

fs.ensureDirSync(buildPath);

for (let contract in output) {
  fs.outputJsonSync(
    path.resolve(buildPath, contract.split(':')[1] + '.json'),
    output[contract]
  );
}
