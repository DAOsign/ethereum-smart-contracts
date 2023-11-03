## Proofs

### EIP712DOMAIN_TYPEHASH

```solidity
bytes32 EIP712DOMAIN_TYPEHASH
```

### SIGNER_TYPEHASH

```solidity
bytes32 SIGNER_TYPEHASH
```

### PROOF_AUTHORITY_TYPEHASH

```solidity
bytes32 PROOF_AUTHORITY_TYPEHASH
```

### PROOF_SIGNATURE_TYPEHASH

```solidity
bytes32 PROOF_SIGNATURE_TYPEHASH
```

### FILECID_TYPEHASH

```solidity
bytes32 FILECID_TYPEHASH
```

### PROOF_AGREEMENT_TYPEHASH

```solidity
bytes32 PROOF_AGREEMENT_TYPEHASH
```

### DOMAIN_HASH

```solidity
bytes32 DOMAIN_HASH
```

### ProofKind

```solidity
enum ProofKind {
  Authority,
  Signature,
  Agreement
}
```

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

### ProofOfAuthority

```solidity
struct ProofOfAuthority {
  string name;
  address from;
  string filecid;
  struct Proofs.Signer[] signers;
  string app;
  uint256 timestamp;
  string metadata;
}
```

### ProofOfSignature

```solidity
struct ProofOfSignature {
  string name;
  address signer;
  string filecid;
  string app;
  uint256 timestamp;
  string metadata;
}
```

### Filecid

```solidity
struct Filecid {
  string addr;
  string data;
}
```

### ProofOfAgreement

```solidity
struct ProofOfAgreement {
  string filecid;
  struct Proofs.Filecid[] signcids;
  string app;
  uint256 timestamp;
  string metadata;
}
```

### constructor

```solidity
constructor() internal
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
function hash(struct Proofs.Signer[] _input) internal pure returns (bytes32)
```

### hash

```solidity
function hash(struct Proofs.ProofOfAuthority _input) internal pure returns (bytes32)
```

### hash

```solidity
function hash(struct Proofs.ProofOfSignature _input) internal pure returns (bytes32)
```

### hash

```solidity
function hash(struct Proofs.Filecid _input) internal pure returns (bytes32)
```

### hash

```solidity
function hash(struct Proofs.Filecid[] _input) internal pure returns (bytes32)
```

### hash

```solidity
function hash(struct Proofs.ProofOfAgreement _input) internal pure returns (bytes32)
```

### recover

```solidity
function recover(struct Proofs.ProofOfAuthority message, bytes signature) public view returns (address)
```

### recover

```solidity
function recover(struct Proofs.ProofOfSignature message, bytes signature) public view returns (address)
```

### recover

```solidity
function recover(struct Proofs.ProofOfAgreement message, bytes signature) public view returns (address)
```

### store

```solidity
function store(struct Proofs.ProofOfAuthority message, bytes signature) public
```

### store

```solidity
function store(struct Proofs.ProofOfSignature message, bytes signature) public
```

### store

```solidity
function store(struct Proofs.ProofOfAgreement message, bytes signature) public
```

### validate

```solidity
function validate(struct Proofs.ProofOfAuthority) internal view virtual returns (bool)
```

### validate

```solidity
function validate(struct Proofs.ProofOfSignature) internal view virtual returns (bool)
```

### validate

```solidity
function validate(struct Proofs.ProofOfAgreement) internal view virtual returns (bool)
```

### save

```solidity
function save(struct Proofs.ProofOfAuthority) internal virtual
```

### save

```solidity
function save(struct Proofs.ProofOfSignature) internal virtual
```

### save

```solidity
function save(struct Proofs.ProofOfAgreement) internal virtual
```

