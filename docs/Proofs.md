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

### myProofKeys

```solidity
mapping(address => bytes32[]) myProofKeys
```

### constructor

```solidity
constructor(address _proofsMetadata, address _admin) public
```

### domain

```solidity
struct IProofs.EIP712Domain domain
```

TODO: move to ProofsMetadata

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

### hash

```solidity
function hash(struct IProofs.EIP712Domain _input) internal pure returns (bytes32)
```

### hash

```solidity
function hash(struct IProofs.Signer _input) internal pure returns (bytes32)
```

### hash

```solidity
function hash(struct IProofs.Signer[] _input) public pure returns (bytes32)
```

### hash

```solidity
function hash(struct IProofs.ProofOfAuthorityMsg _input) public pure returns (bytes32)
```

### recover

```solidity
function recover(struct IProofs.ProofOfAuthorityMsg message, bytes signature) public pure returns (address)
```

### validate

```solidity
function validate(struct IProofs.ProofOfAuthorityMsg message) internal view returns (bool)
```

### save

```solidity
function save(struct IProofs.ProofOfAuthorityMsg message, bytes signature, string version) internal
```

### get

```solidity
function get(struct IProofs.ProofOfAuthorityMsg message) public view returns (struct IProofs.ProofOfAuthorityShrinked)
```

### store

```solidity
function store(struct IProofs.ProofOfAuthorityMsg message, bytes signature, string version) public
```

