import 'dotenv/config';

import { HardhatUserConfig } from 'hardhat/config';
import '@nomicfoundation/hardhat-toolbox';
import 'hardhat-gas-reporter';
import 'solidity-coverage';
import 'solidity-docgen';
import 'hardhat-contract-sizer';
import './tasks';

const { GOERLI_URL, ETHEREUM_MAINNET_URL, PRIVATE_KEY, ETHERSCAN_API_KEY } = process.env;

const config: HardhatUserConfig = {
  solidity: {
    version: '0.8.21',
    settings: {
      optimizer: {
        enabled: true,
        runs: 1000,
      },
    },
  },
  docgen: {
    pages: 'files',
    templates: 'docsBlueprint',
  },
  gasReporter: {
    enabled: process.env.REPORT_GAS === 'true',
  },
  // To verify contracts on Etherscan
  etherscan: {
    apiKey: ETHERSCAN_API_KEY,
  },
  networks: {
    goerli: {
      url: GOERLI_URL || '',
      accounts: PRIVATE_KEY !== undefined ? [PRIVATE_KEY] : [],
    },
    ethereum: {
      url: ETHEREUM_MAINNET_URL || '',
      accounts: PRIVATE_KEY !== undefined ? [PRIVATE_KEY] : [],
    },
  },
};

export default config;
