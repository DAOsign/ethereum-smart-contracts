import 'dotenv/config';

import { HardhatUserConfig } from 'hardhat/config';
import '@nomicfoundation/hardhat-toolbox';
import 'hardhat-gas-reporter';
import 'solidity-coverage';
import 'solidity-docgen';
import 'hardhat-contract-sizer';
import './tasks';

const config: HardhatUserConfig = {
  solidity: '0.8.18',
  docgen: {
    pages: 'files',
    templates: 'docsBlueprint',
  },
  gasReporter: {
    enabled: process.env.REPORT_GAS === 'true',
  },
};

export default config;
