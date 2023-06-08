import { HardhatUserConfig } from 'hardhat/config';
import '@nomicfoundation/hardhat-toolbox';
import 'hardhat-gas-reporter';
import 'solidity-coverage';
import 'solidity-docgen';
import 'hardhat-contract-sizer';
import './tasks';

const config: HardhatUserConfig = {
  solidity: '0.8.18',
};

export default config;
