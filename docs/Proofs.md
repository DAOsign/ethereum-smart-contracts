## ProofKind

```solidity
enum ProofKind {
  Authority,
  Signature,
  Agreement
}
```

## EIP712Domain

```solidity
struct EIP712Domain {
  string name;
  string version;
  uint256 chainId;
  address verifyingContract;
}
```

## EIP712DOMAIN_TYPEHASH

```solidity
bytes32 EIP712DOMAIN_TYPEHASH
```

## Signer

```solidity
struct Signer {
  address addr;
  string data;
}
```

## SIGNER_TYPEHASH

```solidity
bytes32 SIGNER_TYPEHASH
```

## ProofOfAuthority

```solidity
struct ProofOfAuthority {
  string name;
  address from;
  string filecid;
  struct Signer[] signers;
  string app;
  uint256 timestamp;
  string metadata;
}
```

## PROOF_AUTHORITY_TYPEHASH

```solidity
bytes32 PROOF_AUTHORITY_TYPEHASH
```

## ProofOfSignature

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

## PROOF_SIGNATURE_TYPEHASH

```solidity
bytes32 PROOF_SIGNATURE_TYPEHASH
```

## Filecid

```solidity
struct Filecid {
  string addr;
  string data;
}
```

## FILECID_TYPEHASH

```solidity
bytes32 FILECID_TYPEHASH
```

## ProofOfAgreement

```solidity
struct ProofOfAgreement {
  string filecid;
  struct Filecid[] signcids;
  string app;
  uint256 timestamp;
  string metadata;
}
```

## PROOF_AGREEMENT_TYPEHASH

```solidity
bytes32 PROOF_AGREEMENT_TYPEHASH
```

## Proofs

### DOMAIN_HASH

```solidity
bytes32 DOMAIN_HASH
```

### constructor

```solidity
constructor() internal
```

### hash

```solidity
function hash(struct EIP712Domain _input) internal pure returns (bytes32)
```

### hash

```solidity
function hash(struct Signer _input) internal pure returns (bytes32)
```

### hash

```solidity
function hash(struct Signer[] _input) public pure returns (bytes32)
```

### hash

```solidity
function hash(struct ProofOfAuthority _input) public pure returns (bytes32)
```

### hash

```solidity
function hash(struct ProofOfSignature _input) public pure returns (bytes32)
```

### hash

```solidity
function hash(struct Filecid _input) internal pure returns (bytes32)
```

### hash

```solidity
function hash(struct Filecid[] _input) public pure returns (bytes32)
```

### hash

```solidity
function hash(struct ProofOfAgreement _input) public pure returns (bytes32)
```

### recover

```solidity
function recover(bytes32 message, bytes sig) internal pure returns (address)
```

### recover

```solidity
function recover(struct ProofOfAuthority message, bytes signature) public view returns (address)
```

### recover

```solidity
function recover(struct ProofOfSignature message, bytes signature) public view returns (address)
```

### recover

```solidity
function recover(struct ProofOfAgreement message, bytes signature) public view returns (address)
```

### store

```solidity
function store(struct ProofOfAuthority message, bytes signature) public
```

### store

```solidity
function store(struct ProofOfSignature message, bytes signature) public
```

### store

```solidity
function store(struct ProofOfAgreement message, bytes signature) public
```

### validate

```solidity
function validate(struct ProofOfAuthority) internal view virtual returns (bool)
```

### validate

```solidity
function validate(struct ProofOfSignature) internal view virtual returns (bool)
```

### validate

```solidity
function validate(struct ProofOfAgreement) internal view virtual returns (bool)
```

### save

```solidity
function save(struct ProofOfAuthority) internal virtual
```

### save

```solidity
function save(struct ProofOfSignature) internal virtual
```

### save

```solidity
function save(struct ProofOfAgreement) internal virtual
```

## DummyProofs

### data

```solidity
mapping(bytes32 => bytes) data
```

### validate

```solidity
function validate(struct ProofOfAuthority) internal pure returns (bool)
```

### validate

```solidity
function validate(struct ProofOfSignature) internal pure returns (bool)
```

### validate

```solidity
function validate(struct ProofOfAgreement) internal pure returns (bool)
```

### save

```solidity
function save(struct ProofOfAuthority message) internal
```

### save

```solidity
function save(struct ProofOfSignature message) internal
```

### save

```solidity
function save(struct ProofOfAgreement message) internal
```

