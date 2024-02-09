## PROOF_OF_AGREEMENT_TYPEHASH

```solidity
bytes32 PROOF_OF_AGREEMENT_TYPEHASH
```

## ProofOfAgreement

```solidity
struct ProofOfAgreement {
  string authorityCID;
  string[] signatureCIDs;
  string app;
  uint256 timestamp;
  string metadata;
}
```

## EIP712ProofOfAgreementTypes

```solidity
struct EIP712ProofOfAgreementTypes {
  struct EIP712PropertyType[2] EIP712Domain;
  struct EIP712PropertyType[5] ProofOfAgreement;
}
```

## EIP712ProofOfAgreementDocument

```solidity
struct EIP712ProofOfAgreementDocument {
  struct EIP712ProofOfAgreementTypes types;
  struct EIP712Domain domain;
  string primaryType;
  struct ProofOfAgreement message;
}
```

## IEIP712ProofOfAgreement

### hash

```solidity
function hash(struct ProofOfAgreement data) external pure returns (bytes32)
```

### recover

```solidity
function recover(bytes32 domainHash, struct ProofOfAgreement data, bytes signature) external pure returns (address)
```

### toEIP712Message

```solidity
function toEIP712Message(struct EIP712Domain domain, struct ProofOfAgreement message) external view returns (struct EIP712ProofOfAgreementDocument)
```

## EIP712ProofOfAgreement

### proofOfAgreementDoc

```solidity
struct EIP712ProofOfAgreementDocument proofOfAgreementDoc
```

### constructor

```solidity
constructor() public
```

### hash

```solidity
function hash(struct ProofOfAgreement data) public pure returns (bytes32)
```

### recover

```solidity
function recover(bytes32 domainHash, struct ProofOfAgreement data, bytes signature) public pure returns (address)
```

### toEIP712Message

```solidity
function toEIP712Message(struct EIP712Domain domain, struct ProofOfAgreement message) public view returns (struct EIP712ProofOfAgreementDocument)
```

