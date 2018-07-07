const path = require('path');
const fs = require('fs-extra');
const solc = require('solc');
const config = require('./config.json');

const buildPath = path.resolve(__dirname, config.contracts.output);
fs.removeSync(buildPath);

let contractPath;
let source;
let output;

for (let fileIndex in config.contracts.files) {
    contractPath = path.resolve(__dirname, config.contracts.input, config.contracts.files[fileIndex]);
    source = fs.readFileSync(contractPath, 'utf8');
    output = solc.compile(source, 1).contracts;

    fs.ensureDirSync(buildPath);

    for (let contract in output) {
        fs.outputJsonSync(
            path.resolve(buildPath, contract.replace(':', '') + '.json'),
            output[contract]
        );
    }
}
