## EIP712DOMAIN_TYPEHASH

```solidity
bytes32 EIP712DOMAIN_TYPEHASH
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

## SIGNER_TYPEHASH

```solidity
bytes32 SIGNER_TYPEHASH
```

## Signer

```solidity
struct Signer {
  address addr;
  string metadata;
}
```

## METADATA_TYPEHASH

```solidity
bytes32 METADATA_TYPEHASH
```

## Metadata

```solidity
struct Metadata {
  string app;
  string structure;
  uint256 timestamp;
  string metadata;
}
```

## PROOF_AUTHORITY_MSG_TYPEHASH

```solidity
bytes32 PROOF_AUTHORITY_MSG_TYPEHASH
```

## ProofOfAuthorityMsg

```solidity
struct ProofOfAuthorityMsg {
  address from;
  string agreementCID;
  struct Signer[] signers;
  struct Metadata metadata;
}
```

## PROOF_SIGNATURE_MSG_TYPEHASH

```solidity
bytes32 PROOF_SIGNATURE_MSG_TYPEHASH
```

## ProofOfSignatureMsg

```solidity
struct ProofOfSignatureMsg {
  address signer;
  string agreementCID;
  struct Metadata metadata;
}
```

## PROOF_AGREEMENT_MSG_TYPEHASH

```solidity
bytes32 PROOF_AGREEMENT_MSG_TYPEHASH
```

## ProofOfAgreementMsg

```solidity
struct ProofOfAgreementMsg {
  string agreementCID;
  string[] signatureCIDs;
  struct Metadata metadata;
}
```

## DAOSignDecoder

### DOMAIN_HASH

```solidity
bytes32 DOMAIN_HASH
```

### getDomainHash

```solidity
function getDomainHash() public view returns (bytes32)
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
function hash(struct Metadata data) internal pure returns (bytes32)
```

### hash

```solidity
function hash(string[] data) internal pure returns (bytes32)
```

### hash

```solidity
function hash(struct ProofOfAuthorityMsg data) internal pure returns (bytes32)
```

### hash

```solidity
function hash(struct ProofOfSignatureMsg data) internal pure returns (bytes32)
```

### hash

```solidity
function hash(struct ProofOfAgreementMsg data) internal pure returns (bytes32)
```

### recover

```solidity
function recover(bytes32 message, bytes signature) internal pure returns (address)
```

### recover

```solidity
function recover(struct ProofOfAuthorityMsg message, bytes signature) internal view returns (address)
```

### recover

```solidity
function recover(struct ProofOfSignatureMsg message, bytes signature) internal view returns (address)
```

### recover

```solidity
function recover(struct ProofOfAgreementMsg message, bytes signature) internal view returns (address)
```

## SignedProofOfAuthorityMsg

```solidity
struct SignedProofOfAuthorityMsg {
  struct ProofOfAuthorityMsg message;
  bytes signature;
  string proofCID;
}
```

## SignedProofOfSignatureMsg

```solidity
struct SignedProofOfSignatureMsg {
  struct ProofOfSignatureMsg message;
  bytes signature;
  string proofCID;
}
```

## SignedProofOfAgreementMsg

```solidity
struct SignedProofOfAgreementMsg {
  struct ProofOfAgreementMsg message;
  string proofCID;
}
```

## IPFS_CID_LENGHT

```solidity
uint256 IPFS_CID_LENGHT
```

## DAOSignApp

### NewProofOfAuthorityMsg

```solidity
event NewProofOfAuthorityMsg(struct SignedProofOfAuthorityMsg data)
```

### NewProofOfSignatureMsg

```solidity
event NewProofOfSignatureMsg(struct SignedProofOfSignatureMsg data)
```

### NewProofOfAgreementMsg

```solidity
event NewProofOfAgreementMsg(struct SignedProofOfAgreementMsg data)
```

### getProofOfAuthority

```solidity
function getProofOfAuthority(string cid) external view returns (struct SignedProofOfAuthorityMsg)
```

### getProofOfSignature

```solidity
function getProofOfSignature(string cid) external view returns (struct SignedProofOfSignatureMsg)
```

### getProofOfAgreement

```solidity
function getProofOfAgreement(string cid) external view returns (struct SignedProofOfAgreementMsg)
```

### storeProofOfAuthority

```solidity
function storeProofOfAuthority(struct SignedProofOfAuthorityMsg data) external
```

### storeProofOfSignature

```solidity
function storeProofOfSignature(struct SignedProofOfSignatureMsg data) external
```

### storeProofOfAgreement

```solidity
function storeProofOfAgreement(struct SignedProofOfAgreementMsg data) external
```

## DAOSignBaseApp

### proofsOfSignatureCIDs

```solidity
mapping(string => string[]) proofsOfSignatureCIDs
```

### proofs

```solidity
mapping(string => bytes) proofs
```

### memcmp

```solidity
function memcmp(bytes a, bytes b) internal pure returns (bool)
```

### strcmp

```solidity
function strcmp(string a, string b) internal pure returns (bool)
```

### validate

```solidity
function validate(struct Metadata data, string structure) internal view returns (bool)
```

### validate

```solidity
function validate(struct SignedProofOfAuthorityMsg data) internal view returns (bool)
```

### validate

```solidity
function validate(struct SignedProofOfSignatureMsg data) internal view returns (bool)
```

### validate

```solidity
function validate(struct SignedProofOfAgreementMsg data) internal view returns (bool)
```

### getProofOfAuthority

```solidity
function getProofOfAuthority(string cid) external view returns (struct SignedProofOfAuthorityMsg)
```

### getProofOfSignature

```solidity
function getProofOfSignature(string cid) external view returns (struct SignedProofOfSignatureMsg)
```

### getProofOfAgreement

```solidity
function getProofOfAgreement(string cid) external view returns (struct SignedProofOfAgreementMsg)
```

### storeProofOfAuthority

```solidity
function storeProofOfAuthority(struct SignedProofOfAuthorityMsg data) external
```

### storeProofOfSignature

```solidity
function storeProofOfSignature(struct SignedProofOfSignatureMsg data) external
```

### storeProofOfAgreement

```solidity
function storeProofOfAgreement(struct SignedProofOfAgreementMsg data) external
```

