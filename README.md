# DAOsign Smart Contracts

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

## Contributions

Contributions to DAOsign smart contracts are welcomed. Feel free to submit issues, fork the repository, and send pull requests.

## Contact

For any queries, comments, or concerns, please feel free to reach out through our [Github Issues](https://github.com/DAOsign/smart-contracts/issues).

Visit our website at [daosign.org](https://daosign.org/).
