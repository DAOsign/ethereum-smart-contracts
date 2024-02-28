## PROOF_OF_CANCEL_TYPEHASH

```solidity
bytes32 PROOF_OF_CANCEL_TYPEHASH
```

## ProofOfCancel

```solidity
struct ProofOfCancel {
  string[] authorityCIDs;
  uint256 timestamp;
  string metadata;
}
```

## EIP712ProofOfCancelTypes

```solidity
struct EIP712ProofOfCancelTypes {
  struct EIP712PropertyType[2] EIP712Domain;
  struct EIP712PropertyType[3] ProofOfVoid;
}
```

## EIP712ProofOfCancelDocument

```solidity
struct EIP712ProofOfCancelDocument {
  struct EIP712ProofOfCancelTypes types;
  struct EIP712Domain domain;
  string primaryType;
  struct ProofOfCancel message;
}
```

## IEIP712ProofOfCancel

### hash

```solidity
function hash(struct ProofOfCancel data) external pure returns (bytes32)
```

### recover

```solidity
function recover(bytes32 domainHash, struct ProofOfCancel data, bytes signature) external pure returns (address)
```

### toEIP712Message

```solidity
function toEIP712Message(struct EIP712Domain domain, struct ProofOfCancel message) external view returns (struct EIP712ProofOfCancelDocument)
```

## EIP712ProofOfCancel

### proofOfVoidDoc

```solidity
struct EIP712ProofOfCancelDocument proofOfVoidDoc
```

### constructor

```solidity
constructor() public
```

### hash

```solidity
function hash(struct ProofOfCancel data) public pure returns (bytes32)
```

### recover

```solidity
function recover(bytes32 domainHash, struct ProofOfCancel data, bytes signature) public pure returns (address)
```

### toEIP712Message

```solidity
function toEIP712Message(struct EIP712Domain domain, struct ProofOfCancel message) public view returns (struct EIP712ProofOfCancelDocument)
```

