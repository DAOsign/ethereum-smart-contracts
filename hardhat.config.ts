import 'dotenv/config';

import { HardhatUserConfig } from 'hardhat/config';
import '@nomicfoundation/hardhat-toolbox';
import 'hardhat-gas-reporter';
import 'solidity-coverage';
import 'solidity-docgen';
import 'hardhat-contract-sizer';
import './tasks';

const {
  TESTNET_SAPPHIRE_URL,
  SEPOLIA_URL,
  GOERLI_URL,
  ETHEREUM_MAINNET_URL,
  PRIVATE_KEY,
  ETHERSCAN_API_KEY,
  ETHERSCAN_OPTIMISTIC_API_KEY,
} = process.env;

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
    apiKey: {
      goerli: ETHERSCAN_API_KEY!,
      sepolia: ETHERSCAN_OPTIMISTIC_API_KEY!,
    },
    customChains: [
      {
        network: 'sepolia',
        chainId: 11155420,
        urls: {
          apiURL: 'https://api-sepolia-optimistic.etherscan.io/api',
          browserURL: 'https://sepolia-optimism.etherscan.io/',
        },
      },
    ],
  },
  networks: {
    hardhat: {
      allowUnlimitedContractSize: true,
    },
    goerli: {
      url: GOERLI_URL || '',
      accounts: PRIVATE_KEY !== undefined ? [PRIVATE_KEY] : [],
    },
    ethereum: {
      url: ETHEREUM_MAINNET_URL || '',
      accounts: PRIVATE_KEY !== undefined ? [PRIVATE_KEY] : [],
    },
    sepolia: {
      url: SEPOLIA_URL || '',
      accounts: PRIVATE_KEY !== undefined ? [PRIVATE_KEY] : [],
    },
    testnetsapphire: {
      url: TESTNET_SAPPHIRE_URL || '',
      accounts: PRIVATE_KEY !== undefined ? [PRIVATE_KEY] : [],
    },
  },
};

export default config;
