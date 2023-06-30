## Proofs

Stores DAOsign proofs.

### proofsMetadata

```solidity
address proofsMetadata
```

### constructor

```solidity
constructor(address _proofsMetadata) public
```

### getProofOfAuthorityData

```solidity
function getProofOfAuthorityData(address creator, address[] signers, string agreementFileCID, string version) public view returns (string)
```

Public:
    - Create Proof-of-Authority data (given a creator's address, agreementFileCID, and the list of signers)
    - Create Proof-of-Signature (given a signer's address and Proof-of-Authority IPFS CID)
    - Sign (off-chain), store & verify signature of the data (used for any proof), generate proof IPFS CID

    System:
    - autogenereate Proof-of-Agreement

### getProofOfAuthorityDataMessage

```solidity
function getProofOfAuthorityDataMessage(address creator, address[] signers, string agreementFileCID) public view returns (string)
```

### generateSignersJSON

```solidity
function generateSignersJSON(address[] signers) public pure returns (string)
```

