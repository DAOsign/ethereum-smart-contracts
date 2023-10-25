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
npx hardhat compile
```

Then deploy smart contracts to the target network and verify them on Etherscan.

```
npx hardhat deploy:all --owner <your address> --network goerli
```

## Latest Deployments

### 6 Oct 2023

StringsExpanded &nbsp;&nbsp;`0xC7eb777864D0A507524eC8134ff185bab4A1A701`<br>
ProofsMetadata &nbsp;&nbsp;&nbsp;&nbsp;`0xBB1dDe7b8490Bf12D275aA0ceBB827A0371eC7C2`<br>
ProofsVerification &nbsp;`0x8c6E589E9CF159C84356C8719E40D27535520BBA`<br>
ProofsHelper &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`0xD9B11cd550Cf7CDbC9915D325d37F746354d9a38`<br>
Proofs &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`0x3C0A2766F77Afdb70A834cd4960cC5d695076497`<br>

## Contributions

Contributions to DAOsign smart contracts are welcomed. Feel free to submit issues, fork the repository, and send pull requests.

## Contact

For any queries, comments, or concerns, please feel free to reach out through our [Github Issues](https://github.com/DAOsign/smart-contracts/issues).

Visit our website at [daosign.org](https://daosign.org/).
