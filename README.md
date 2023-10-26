# DAOsign Smart Contracts

# ⚠️ Work In Progress! Use at Your Own Risk! ⚠️

This repository houses a collection of Ethereum smart contracts, developed as part of the DAOsign project. DAOsign leverages blockchain technology to generate, store, and validate Agreement Proofs.

## Overview

DAOsign aims to transition the generation, storage, and validation of Agreement Proofs from IPFS to the blockchain. This shift carries numerous benefits:

- **Longevity**: Unlike data on IPFS, which may disappear if no nodes are interested in storing it, blockchain data is immutable and perpetually accessible.
- **Immutability**: Tampering with data on blockchains like Ethereum or Polygon is considerably more challenging than on IPFS.
- **Publicity**: The transparent nature of blockchain enables users to trust proofs created on the platform. Both the logic of creating the proof and the proof itself are publicly accessible. Moreover, all signatures can be verified on-chain.

## Features

The smart contracts in this repository:

- Store metadata related to Agreement Proofs.
- Store Agreement Proofs data.
- Validate user signatures.

## Installation

To install and use this project, follow these steps:

1. Clone the repository:

```
git clone https://github.com/DAOsign/smart-contracts.git
```

2. Move to the project directory:

```
cd smart-contracts
```

3. Install dependencies using Yarn:

```
yarn install
```

4. Test the smart contracts:

```
yarn test
```

## Smart Contract Documentation

For detailed information about individual contracts, refer to the [documentation](./docs).

## Deployment

To deploy smart contracts and libraries to Ethereum Mainnet or Goerli Testnet you can use the following commands.

### Deploy all contracts and libraries

Before deploying the contracts make sure they are compiled.

```
yarn hardhat compile
```

Then deploy smart contracts to the target network and verify them on Etherscan.

```
yarn hardhat deploy:all --owner <your address> --network goerli
```

## Verification

To verify smart contracts on Etherscan execute these commands

```
yarn hardhat verify --network goerli <StringsExpanded addr>
yarn hardhat verify --network goerli <ProofsMetadata addr>
yarn hardhat verify --network goerli <ProofsHelper addr>
yarn hardhat verify --network goerli <ProofsVerification addr>
yarn hardhat verify --network goerli <Proofs addr> <ProofsMetadata addr> <your address (a.k.a. owner address)>
```

Or a generalized command for any smart contract would be

```
yarn hardhat verify --network goerli <contract address> <constructor params space separated>
```

## Latest Deployments

### 25 Oct 2023

StringsExpanded &nbsp;&nbsp;`0xB9130909edB2Df74996B32064657e38ACcC03Cbd`<br>
ProofsMetadata &nbsp;&nbsp;&nbsp;&nbsp;`0x37958Dd1866E5aE3F16b8e4c7ebBd1D3B1AA6b42`<br>
ProofsVerification &nbsp;`0x2853255D6e9136A520375E0B4eeAeb1eB26278e1`<br>
ProofsHelper &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`0x78A4897C429D9F49E814C95C71DEceB4E7391967`<br>
Proofs &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`0x9A6d8b61Fb6F2cc463ABb8D1E7cb8D77e7F7CCe5`<br>

## Contributions

Contributions to DAOsign smart contracts are welcomed. Feel free to submit issues, fork the repository, and send pull requests.

## Contact

For any queries, comments, or concerns, please feel free to reach out through our [Github Issues](https://github.com/DAOsign/smart-contracts/issues).

Visit our website at [daosign.org](https://daosign.org/).
