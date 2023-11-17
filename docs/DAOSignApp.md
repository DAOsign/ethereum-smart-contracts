## IPFS_CID_LENGHT

```solidity
uint256 IPFS_CID_LENGHT
```

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

## DAOSignBaseApp

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

## DAOSignApp

### poaus

```solidity
mapping(string => struct SignedProofOfAuthority) poaus
```

### posis

```solidity
mapping(string => struct SignedProofOfSignature) posis
```

### poags

```solidity
mapping(string => struct SignedProofOfAgreement) poags
```

### proof2signer

```solidity
mapping(string => address) proof2signer
```

### poauSignersIdx

```solidity
mapping(string => mapping(address => uint256)) poauSignersIdx
```

### constructor

```solidity
constructor() public
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
function validate(struct SignedProofOfAuthority data) internal pure returns (bool)
```

### validate

```solidity
function validate(struct SignedProofOfSignature data) internal view returns (bool)
```

### validate

```solidity
function validate(struct SignedProofOfAgreement data) internal view returns (bool)
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

