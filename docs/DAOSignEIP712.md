## DAOSignEIP712

### EIP712DOMAIN_TYPEHASH

```solidity
bytes32 EIP712DOMAIN_TYPEHASH
```

### SIGNER_TYPEHASH

```solidity
bytes32 SIGNER_TYPEHASH
```

### PROOF_OF_AUTHORITY_TYPEHASH

```solidity
bytes32 PROOF_OF_AUTHORITY_TYPEHASH
```

### PROOF_OF_SIGNATURE_TYPEHASH

```solidity
bytes32 PROOF_OF_SIGNATURE_TYPEHASH
```

### PROOF_OF_AGREEMENT_TYPEHASH

```solidity
bytes32 PROOF_OF_AGREEMENT_TYPEHASH
```

### DOMAIN_HASH

```solidity
bytes32 DOMAIN_HASH
```

### domain

```solidity
struct DAOSignEIP712.EIP712Domain domain
```

### proofOfAuthorityDoc

```solidity
struct DAOSignEIP712.EIP712ProofOfAuthority proofOfAuthorityDoc
```

### proofOfSignatureDoc

```solidity
struct DAOSignEIP712.EIP712ProofOfSignature proofOfSignatureDoc
```

### proofOfAgreementDoc

```solidity
struct DAOSignEIP712.EIP712ProofOfAgreement proofOfAgreementDoc
```

### EIP712Domain

```solidity
struct EIP712Domain {
  string name;
  string version;
  uint256 chainId;
  address verifyingContract;
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
  string agreementCID;
  struct DAOSignEIP712.Signer[] signers;
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
  string agreementCID;
  string app;
  uint256 timestamp;
  string metadata;
}
```

### ProofOfAgreement

```solidity
struct ProofOfAgreement {
  string agreementCID;
  string[] signatureCIDs;
  string app;
  uint256 timestamp;
  string metadata;
}
```

### EIP712PropertyType

```solidity
struct EIP712PropertyType {
  string name;
  string kind;
}
```

### EIP712ProofOfAuthorityTypes

```solidity
struct EIP712ProofOfAuthorityTypes {
  struct DAOSignEIP712.EIP712PropertyType[4] EIP712Domain;
  struct DAOSignEIP712.EIP712PropertyType[2] Signer;
  struct DAOSignEIP712.EIP712PropertyType[7] ProofOfAuthority;
}
```

### EIP712ProofOfAuthority

```solidity
struct EIP712ProofOfAuthority {
  struct DAOSignEIP712.EIP712ProofOfAuthorityTypes types;
  struct DAOSignEIP712.EIP712Domain domain;
  string primaryType;
  struct DAOSignEIP712.ProofOfAuthority message;
}
```

### EIP712ProofOfSignatureTypes

```solidity
struct EIP712ProofOfSignatureTypes {
  struct DAOSignEIP712.EIP712PropertyType[4] EIP712Domain;
  struct DAOSignEIP712.EIP712PropertyType[6] ProofOfSignature;
}
```

### EIP712ProofOfSignature

```solidity
struct EIP712ProofOfSignature {
  struct DAOSignEIP712.EIP712ProofOfSignatureTypes types;
  struct DAOSignEIP712.EIP712Domain domain;
  string primaryType;
  struct DAOSignEIP712.ProofOfSignature message;
}
```

### EIP712ProofOfAgreementTypes

```solidity
struct EIP712ProofOfAgreementTypes {
  struct DAOSignEIP712.EIP712PropertyType[4] EIP712Domain;
  struct DAOSignEIP712.EIP712PropertyType[5] ProofOfAgreement;
}
```

### EIP712ProofOfAgreement

```solidity
struct EIP712ProofOfAgreement {
  struct DAOSignEIP712.EIP712ProofOfAgreementTypes types;
  struct DAOSignEIP712.EIP712Domain domain;
  string primaryType;
  struct DAOSignEIP712.ProofOfAgreement message;
}
```

### initEIP712Types

```solidity
function initEIP712Types() internal
```

### hash

```solidity
function hash(struct DAOSignEIP712.EIP712Domain data) internal pure returns (bytes32)
```

### hash

```solidity
function hash(struct DAOSignEIP712.Signer data) internal pure returns (bytes32)
```

### hash

```solidity
function hash(struct DAOSignEIP712.Signer[] data) internal pure returns (bytes32)
```

### hash

```solidity
function hash(struct DAOSignEIP712.ProofOfAuthority data) internal pure returns (bytes32)
```

### hash

```solidity
function hash(struct DAOSignEIP712.ProofOfSignature data) internal pure returns (bytes32)
```

### hash

```solidity
function hash(string[] data) internal pure returns (bytes32)
```

### hash

```solidity
function hash(struct DAOSignEIP712.ProofOfAgreement data) internal pure returns (bytes32)
```

### recover

```solidity
function recover(bytes32 message, bytes sig) internal pure returns (address)
```

### recover

```solidity
function recover(struct DAOSignEIP712.ProofOfAuthority data, bytes signature) internal view returns (address)
```

### recover

```solidity
function recover(struct DAOSignEIP712.ProofOfSignature data, bytes signature) internal view returns (address)
```

### recover

```solidity
function recover(struct DAOSignEIP712.ProofOfAgreement data, bytes signature) internal view returns (address)
```

### toEIP712Message

```solidity
function toEIP712Message(struct DAOSignEIP712.ProofOfAuthority message) internal view returns (struct DAOSignEIP712.EIP712ProofOfAuthority)
```

### toEIP712Message

```solidity
function toEIP712Message(struct DAOSignEIP712.ProofOfSignature message) internal view returns (struct DAOSignEIP712.EIP712ProofOfSignature)
```

### toEIP712Message

```solidity
function toEIP712Message(struct DAOSignEIP712.ProofOfAgreement message) internal view returns (struct DAOSignEIP712.EIP712ProofOfAgreement)
```

