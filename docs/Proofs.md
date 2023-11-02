## Proofs

Stores DAOsign proofs.

Note
Proof-of-Authority = PoA
Proof-of-Signature = PoS
Proof-of-Agreement = PoAg

### proofsMetadata

```solidity
address proofsMetadata
```

Functions from variables

### finalProofs

```solidity
mapping(string => mapping(string => string)) finalProofs
```

### poaData

```solidity
mapping(bytes32 => string) poaData
```

### posData

```solidity
mapping(bytes32 => string) posData
```

### poagData

```solidity
mapping(bytes32 => string) poagData
```

### constructor

```solidity
constructor(address _proofsMetadata, address _admin) public
```

### storeProofOfAuthority

```solidity
function storeProofOfAuthority(address _creator, address[] _signers, string _version, bytes _signature, string _fileCID, string _proofCID) external
```

Stores Proof-of-Authority after verifying the correctness of the signature

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _creator | address | Agreement creator address |
| _signers | address[] | List of signer addresses |
| _version | string |  |
| _signature | bytes | Signature of Proof-of-Authority data |
| _fileCID | string | IPFS CID of the agreement file |
| _proofCID | string | IPFS CID of Proof-of-Authority |

### EIP712Domain

```solidity
struct EIP712Domain {
  string name;
  string version;
}
```

### Signer

```solidity
struct Signer {
  address addr;
  string metadata;
}
```

### ProofOfAuthorityMsg

```solidity
struct ProofOfAuthorityMsg {
  string name;
  address from;
  string agreementFileCID;
  struct Proofs.Signer[] signers;
  string app;
  uint64 timestamp;
  string metadata;
}
```

### ProofOfAuthorityShrinked

```solidity
struct ProofOfAuthorityShrinked {
  bytes sig;
  string version;
  struct Proofs.ProofOfAuthorityMsg message;
}
```

### domain

```solidity
struct Proofs.EIP712Domain domain
```

constructor

### EIP712DOMAIN_TYPEHASH

```solidity
bytes32 EIP712DOMAIN_TYPEHASH
```

### PROOF_AUTHORITY_TYPEHASH

```solidity
bytes32 PROOF_AUTHORITY_TYPEHASH
```

### SIGNER_TYPEHASH

```solidity
bytes32 SIGNER_TYPEHASH
```

### proofs

```solidity
mapping(bytes32 => bytes) proofs
```

### hash

```solidity
function hash(struct Proofs.EIP712Domain _input) internal pure returns (bytes32)
```

### hash

```solidity
function hash(struct Proofs.Signer _input) internal pure returns (bytes32)
```

### hash

```solidity
function hash(struct Proofs.Signer[] _input) public pure returns (bytes32)
```

### hash

```solidity
function hash(struct Proofs.ProofOfAuthorityMsg _input) public pure returns (bytes32)
```

### recover

```solidity
function recover(struct Proofs.ProofOfAuthorityMsg message, bytes signature) public pure returns (address)
```

### validate

```solidity
function validate(struct Proofs.ProofOfAuthorityMsg message) internal view returns (bool)
```

### save

```solidity
function save(struct Proofs.ProofOfAuthorityMsg message, bytes signature, string version) internal
```

### get

```solidity
function get(struct Proofs.ProofOfAuthorityMsg message) public view returns (struct Proofs.ProofOfAuthorityShrinked)
```

### store

```solidity
function store(struct Proofs.ProofOfAuthorityMsg message, bytes signature, string version) public
```

### storeProofOfSignature

```solidity
function storeProofOfSignature(address _signer, bytes _signature, string _fileCID, string _posCID, string _poaCID, string _version) external
```

Stores Proof-of-Signature after verifying the correctness of the signature

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _signer | address | Current signer of the agreement from the list of agreement signers |
| _signature | bytes | Signature of Proof-of-Signature data |
| _fileCID | string | IPFS CID of the agreement file |
| _posCID | string | IPFS CID of Proof-of-Signature |
| _poaCID | string |  |
| _version | string |  |

### storeProofOfAgreement

```solidity
function storeProofOfAgreement(string _fileCID, string _poaCID, string[] _posCIDs, string _poagCID) external
```

Stores Proof-of-Agreement

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _fileCID | string | IPFS CID of the agreement file |
| _poaCID | string | IPFS CID of Proof-of-Authority |
| _posCIDs | string[] | IPFS CIDs of Proof-of-Signature |
| _poagCID | string | IPFS CID of Proof-of-Agreement |

### getPoAData

```solidity
function getPoAData(address _creator, address[] _signers, string _fileCID, string _version) public view returns (string)
```

### getPoSData

```solidity
function getPoSData(address _signer, string _fileCID, string _poaCID, string _version) public view returns (string)
```

### getPoAgData

```solidity
function getPoAgData(string _fileCID, string _poaCID, string[] _posCIDs) public view returns (string)
```

### _setPoAData

```solidity
function _setPoAData(address _creator, address[] _signers, string _fileCID, string _version, string _data) internal
```

### _setPoSData

```solidity
function _setPoSData(address _signer, string _fileCID, string _poaCID, string _version, string _data) internal
```

### _setPoAgData

```solidity
function _setPoAgData(string _fileCID, string _poaCID, string[] _posCID, string _data) internal
```

