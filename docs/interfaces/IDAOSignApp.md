## SignedProofOfAuthority

```solidity
struct SignedProofOfAuthority {
  struct ProofOfAuthority message;
  bytes signature;
  string proofCID;
}
```

## SignedProofOfAuthorityMsg

```solidity
struct SignedProofOfAuthorityMsg {
  struct EIP712ProofOfAuthority message;
  bytes signature;
}
```

## SignedProofOfSignature

```solidity
struct SignedProofOfSignature {
  struct ProofOfSignature message;
  bytes signature;
  string proofCID;
}
```

## SignedProofOfSignatureMsg

```solidity
struct SignedProofOfSignatureMsg {
  struct EIP712ProofOfSignature message;
  bytes signature;
}
```

## SignedProofOfAgreement

```solidity
struct SignedProofOfAgreement {
  struct ProofOfAgreement message;
  bytes signature;
  string proofCID;
}
```

## SignedProofOfAgreementMsg

```solidity
struct SignedProofOfAgreementMsg {
  struct EIP712ProofOfAgreement message;
  bytes signature;
}
```

## IDAOSignApp

### NewProofOfAuthority

```solidity
event NewProofOfAuthority(struct SignedProofOfAuthority data)
```

### NewProofOfSignature

```solidity
event NewProofOfSignature(struct SignedProofOfSignature data)
```

### NewProofOfAgreement

```solidity
event NewProofOfAgreement(struct SignedProofOfAgreement data)
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
function storeProofOfAuthority(struct SignedProofOfAuthority data) external
```

### storeProofOfSignature

```solidity
function storeProofOfSignature(struct SignedProofOfSignature data) external
```

### storeProofOfAgreement

```solidity
function storeProofOfAgreement(struct SignedProofOfAgreement data) external
```

