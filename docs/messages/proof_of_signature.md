## PROOF_OF_SIGNATURE_TYPEHASH

```solidity
bytes32 PROOF_OF_SIGNATURE_TYPEHASH
```

## ProofOfSignature

```solidity
struct ProofOfSignature {
  string name;
  address signer;
  string authorityCID;
  string app;
  uint256 timestamp;
  string metadata;
}
```

## EIP712ProofOfSignatureTypes

```solidity
struct EIP712ProofOfSignatureTypes {
  struct EIP712PropertyType[2] EIP712Domain;
  struct EIP712PropertyType[6] ProofOfSignature;
}
```

## EIP712ProofOfSignatureDocument

```solidity
struct EIP712ProofOfSignatureDocument {
  struct EIP712ProofOfSignatureTypes types;
  struct EIP712Domain domain;
  string primaryType;
  struct ProofOfSignature message;
}
```

## IEIP712ProofOfSignature

### hash

```solidity
function hash(struct ProofOfSignature data) external pure returns (bytes32)
```

### recover

```solidity
function recover(bytes32 domainHash, struct ProofOfSignature data, bytes signature) external pure returns (address)
```

### toEIP712Message

```solidity
function toEIP712Message(struct EIP712Domain domain, struct ProofOfSignature message) external view returns (struct EIP712ProofOfSignatureDocument)
```

## EIP712ProofOfSignature

### proofOfSignatureDoc

```solidity
struct EIP712ProofOfSignatureDocument proofOfSignatureDoc
```

### constructor

```solidity
constructor() public
```

### hash

```solidity
function hash(struct ProofOfSignature data) public pure returns (bytes32)
```

### recover

```solidity
function recover(bytes32 domainHash, struct ProofOfSignature data, bytes signature) public pure returns (address)
```

### toEIP712Message

```solidity
function toEIP712Message(struct EIP712Domain domain, struct ProofOfSignature message) public view returns (struct EIP712ProofOfSignatureDocument)
```

