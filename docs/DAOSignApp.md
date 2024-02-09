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
  struct EIP712ProofOfAuthorityDocument message;
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
  struct EIP712ProofOfSignatureDocument message;
  bytes signature;
}
```

## SignedProofOfAgreement

```solidity
struct SignedProofOfAgreement {
  struct ProofOfAgreement message;
  string proofCID;
}
```

## SignedProofOfAgreementMsg

```solidity
struct SignedProofOfAgreementMsg {
  struct EIP712ProofOfAgreementDocument message;
}
```

## SignedProofOfVoid

```solidity
struct SignedProofOfVoid {
  struct ProofOfVoid message;
  bytes signature;
  string proofCID;
}
```

## SignedProofOfVoidMsg

```solidity
struct SignedProofOfVoidMsg {
  struct EIP712ProofOfVoidDocument message;
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

### NewProofOfVoid

```solidity
event NewProofOfVoid(struct SignedProofOfVoid data)
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

### getProofOfVoid

```solidity
function getProofOfVoid(string cid) external view returns (struct SignedProofOfVoidMsg)
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

### storeProofOfVoid

```solidity
function storeProofOfVoid(struct SignedProofOfVoid data) external
```

## DAOSignApp

### IPFS_CID_LENGTH

```solidity
uint256 IPFS_CID_LENGTH
```

### domain

```solidity
struct EIP712Domain domain
```

### domainHash

```solidity
bytes32 domainHash
```

### proofOfAuthority

```solidity
contract IEIP721ProofOfAuthority proofOfAuthority
```

### proofOfSignature

```solidity
contract IEIP712ProofOfSignature proofOfSignature
```

### proofOfAgreement

```solidity
contract IEIP712ProofOfAgreement proofOfAgreement
```

### proofOfVoid

```solidity
contract IEIP712ProofOfVoid proofOfVoid
```

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

### pov

```solidity
mapping(string => struct SignedProofOfVoid) pov
```

### voided

```solidity
mapping(string => bool) voided
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
constructor(address _proofOfAuthority, address _proofOfSignature, address _proofOfAgreement, address _proofOfVoid, address _tradeFI) public
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

### storeProofOfVoid

```solidity
function storeProofOfVoid(struct SignedProofOfVoid data) external
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

### getProofOfVoid

```solidity
function getProofOfVoid(string cid) external view returns (struct SignedProofOfVoidMsg)
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

### validate

```solidity
function validate(struct SignedProofOfVoid data) internal view returns (bool)
```

