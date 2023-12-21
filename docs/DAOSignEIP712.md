## EIP712Domain

```solidity
struct EIP712Domain {
  string name;
  string version;
  uint256 chainId;
  address verifyingContract;
}
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
  string app;
  uint256 timestamp;
  string metadata;
}
```

## ProofOfSignature

```solidity
struct ProofOfSignature {
  string name;
  address signer;
  string agreementCID;
  string app;
  uint256 timestamp;
  string metadata;
}
```

## ProofOfAgreement

```solidity
struct ProofOfAgreement {
  string agreementCID;
  string[] signatureCIDs;
  string app;
  uint256 timestamp;
  string metadata;
}
```

## EIP712PropertyType

```solidity
struct EIP712PropertyType {
  string name;
  string kind;
}
```

## EIP712ProofOfAuthorityTypes

```solidity
struct EIP712ProofOfAuthorityTypes {
  struct EIP712PropertyType[4] EIP712Domain;
  struct EIP712PropertyType[2] Signer;
  struct EIP712PropertyType[7] ProofOfAuthority;
}
```

## EIP712ProofOfAuthority

```solidity
struct EIP712ProofOfAuthority {
  struct EIP712ProofOfAuthorityTypes types;
  struct EIP712Domain domain;
  string primaryType;
  struct ProofOfAuthority message;
}
```

## EIP712ProofOfSignatureTypes

```solidity
struct EIP712ProofOfSignatureTypes {
  struct EIP712PropertyType[4] EIP712Domain;
  struct EIP712PropertyType[6] ProofOfSignature;
}
```

## EIP712ProofOfSignature

```solidity
struct EIP712ProofOfSignature {
  struct EIP712ProofOfSignatureTypes types;
  struct EIP712Domain domain;
  string primaryType;
  struct ProofOfSignature message;
}
```

## EIP712ProofOfAgreementTypes

```solidity
struct EIP712ProofOfAgreementTypes {
  struct EIP712PropertyType[4] EIP712Domain;
  struct EIP712PropertyType[5] ProofOfAgreement;
}
```

## EIP712ProofOfAgreement

```solidity
struct EIP712ProofOfAgreement {
  struct EIP712ProofOfAgreementTypes types;
  struct EIP712Domain domain;
  string primaryType;
  struct ProofOfAgreement message;
}
```

## EIP712DOMAIN_TYPEHASH

```solidity
bytes32 EIP712DOMAIN_TYPEHASH
```

## SIGNER_TYPEHASH

```solidity
bytes32 SIGNER_TYPEHASH
```

## PROOF_OF_AUTHORITY_TYPEHASH

```solidity
bytes32 PROOF_OF_AUTHORITY_TYPEHASH
```

## PROOF_OF_SIGNATURE_TYPEHASH

```solidity
bytes32 PROOF_OF_SIGNATURE_TYPEHASH
```

## PROOF_OF_AGREEMENT_TYPEHASH

```solidity
bytes32 PROOF_OF_AGREEMENT_TYPEHASH
```

## DAOSignEIP712

### DOMAIN_HASH

```solidity
bytes32 DOMAIN_HASH
```

### domain

```solidity
struct EIP712Domain domain
```

### proofOfAuthorityDoc

```solidity
struct EIP712ProofOfAuthority proofOfAuthorityDoc
```

### proofOfSignatureDoc

```solidity
struct EIP712ProofOfSignature proofOfSignatureDoc
```

### proofOfAgreementDoc

```solidity
struct EIP712ProofOfAgreement proofOfAgreementDoc
```

### initEIP712Types

```solidity
function initEIP712Types() internal
```

### hash

```solidity
function hash(struct EIP712Domain data) internal pure returns (bytes32)
```

### hash

```solidity
function hash(struct Signer data) internal pure returns (bytes32)
```

### hash

```solidity
function hash(struct Signer[] data) internal pure returns (bytes32)
```

### hash

```solidity
function hash(struct ProofOfAuthority data) internal pure virtual returns (bytes32)
```

### hash

```solidity
function hash(struct ProofOfSignature data) internal pure virtual returns (bytes32)
```

### hash

```solidity
function hash(string[] data) internal pure returns (bytes32)
```

### hash

```solidity
function hash(struct ProofOfAgreement data) internal pure virtual returns (bytes32)
```

### recover

```solidity
function recover(bytes32 message, bytes sig) internal pure returns (address)
```

### recover

```solidity
function recover(struct ProofOfAuthority data, bytes signature) internal view virtual returns (address)
```

### recover

```solidity
function recover(struct ProofOfSignature data, bytes signature) internal view virtual returns (address)
```

### recover

```solidity
function recover(struct ProofOfAgreement data, bytes signature) internal view virtual returns (address)
```

### toEIP712Message

```solidity
function toEIP712Message(struct ProofOfAuthority message) internal view returns (struct EIP712ProofOfAuthority)
```

### toEIP712Message

```solidity
function toEIP712Message(struct ProofOfSignature message) internal view returns (struct EIP712ProofOfSignature)
```

### toEIP712Message

```solidity
function toEIP712Message(struct ProofOfAgreement message) internal view returns (struct EIP712ProofOfAgreement)
```

