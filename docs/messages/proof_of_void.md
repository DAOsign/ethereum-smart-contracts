## PROOF_OF_VOID_TYPEHASH

```solidity
bytes32 PROOF_OF_VOID_TYPEHASH
```

## ProofOfVoid

```solidity
struct ProofOfVoid {
  string authorityCID;
  uint256 timestamp;
  string metadata;
}
```

## EIP712ProofOfVoidTypes

```solidity
struct EIP712ProofOfVoidTypes {
  struct EIP712PropertyType[2] EIP712Domain;
  struct EIP712PropertyType[3] ProofOfVoid;
}
```

## EIP712ProofOfVoidDocument

```solidity
struct EIP712ProofOfVoidDocument {
  struct EIP712ProofOfVoidTypes types;
  struct EIP712Domain domain;
  string primaryType;
  struct ProofOfVoid message;
}
```

## IEIP712ProofOfVoid

### hash

```solidity
function hash(struct ProofOfVoid data) external pure returns (bytes32)
```

### recover

```solidity
function recover(bytes32 domainHash, struct ProofOfVoid data, bytes signature) external pure returns (address)
```

### toEIP712Message

```solidity
function toEIP712Message(struct EIP712Domain domain, struct ProofOfVoid message) external view returns (struct EIP712ProofOfVoidDocument)
```

## EIP712ProofOfVoid

### proofOfVoidDoc

```solidity
struct EIP712ProofOfVoidDocument proofOfVoidDoc
```

### constructor

```solidity
constructor() public
```

### hash

```solidity
function hash(struct ProofOfVoid data) public pure returns (bytes32)
```

### recover

```solidity
function recover(bytes32 domainHash, struct ProofOfVoid data, bytes signature) public pure returns (address)
```

### toEIP712Message

```solidity
function toEIP712Message(struct EIP712Domain domain, struct ProofOfVoid message) public view returns (struct EIP712ProofOfVoidDocument)
```

