## SIGNER_TYPEHASH

```solidity
bytes32 SIGNER_TYPEHASH
```

## PROOF_OF_AUTHORITY_TYPEHASH

```solidity
bytes32 PROOF_OF_AUTHORITY_TYPEHASH
```

## Signer

```solidity
struct Signer {
  address addr;
  string metadata;
}
```

## ProofOfAuthority

```solidity
struct ProofOfAuthority {
  string name;
  address from;
  string agreementCID;
  struct Signer[] signers;
  uint256 timestamp;
  string metadata;
}
```

## EIP712ProofOfAuthorityTypes

```solidity
struct EIP712ProofOfAuthorityTypes {
  struct EIP712PropertyType[2] EIP712Domain;
  struct EIP712PropertyType[2] Signer;
  struct EIP712PropertyType[6] ProofOfAuthority;
}
```

## EIP712ProofOfAuthorityDocument

```solidity
struct EIP712ProofOfAuthorityDocument {
  struct EIP712ProofOfAuthorityTypes types;
  struct EIP712Domain domain;
  string primaryType;
  struct ProofOfAuthority message;
}
```

## IEIP721ProofOfAuthority

### hash

```solidity
function hash(struct ProofOfAuthority data) external pure returns (bytes32)
```

### recover

```solidity
function recover(bytes32 domainHash, struct ProofOfAuthority data, bytes signature) external pure returns (address)
```

### toEIP712Message

```solidity
function toEIP712Message(struct EIP712Domain domain, struct ProofOfAuthority message) external view returns (struct EIP712ProofOfAuthorityDocument)
```

## EIP721ProofOfAuthority

### proofOfAuthorityDoc

```solidity
struct EIP712ProofOfAuthorityDocument proofOfAuthorityDoc
```

### constructor

```solidity
constructor() public
```

### hash

```solidity
function hash(struct ProofOfAuthority data) public pure returns (bytes32)
```

### recover

```solidity
function recover(bytes32 domainHash, struct ProofOfAuthority data, bytes signature) public pure returns (address)
```

### toEIP712Message

```solidity
function toEIP712Message(struct EIP712Domain domain, struct ProofOfAuthority message) public view returns (struct EIP712ProofOfAuthorityDocument)
```

