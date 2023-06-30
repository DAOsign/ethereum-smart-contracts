## Proofs

Stores DAOsign proofs.

### proofsMetadata

```solidity
address proofsMetadata
```

### proofsVerificationLib

```solidity
address proofsVerificationLib
```

### signedProofs

```solidity
mapping(string => mapping(string => string)) signedProofs
```

### proofsData

```solidity
mapping(string => mapping(string => string)) proofsData
```

### constructor

```solidity
constructor(address _proofsMetadata, address _proofsVerificationLib) public
```

### getProofOfAuthorityData

```solidity
function getProofOfAuthorityData(address _creator, address[] _signers, string _agreementFileCID, string _version) public view returns (string)
```

Public:
    - Create Proof-of-Authority data (given a creator's address, agreementFileCID, and the list of signers)
    - Create Proof-of-Signature (given a signer's address and Proof-of-Authority IPFS CID)
    - Sign (off-chain), store & verify signature of the data (used for any proof), generate proof IPFS CID

    System:
    - autogenereate Proof-of-Agreement

### getProofOfSignatureData

```solidity
function getProofOfSignatureData(address _signer, string _proofOfAuthorityCID, string _version) public view returns (string)
```

### storeProofOfAuthority

```solidity
function storeProofOfAuthority(string _signature, address _creator, address[] _signers, string _agreementFileCID, string _version) public
```

### _getProofOfAuthorityDataMessage

```solidity
function _getProofOfAuthorityDataMessage(address _creator, address[] _signers, string _agreementFileCID) internal view returns (string)
```

### _getProofOfSignatureDataMessage

```solidity
function _getProofOfSignatureDataMessage(address _signer, string _proofOfAuthorityCID) internal view returns (string)
```

### _generateSignersJSON

```solidity
function _generateSignersJSON(address[] _signers) internal pure returns (string)
```

