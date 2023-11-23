## DAOSignApp

### IPFS_CID_LENGHT

```solidity
uint256 IPFS_CID_LENGHT
```

### poaus

```solidity
mapping(string => struct DAOSignApp.SignedProofOfAuthority) poaus
```

### posis

```solidity
mapping(string => struct DAOSignApp.SignedProofOfSignature) posis
```

### poags

```solidity
mapping(string => struct DAOSignApp.SignedProofOfAgreement) poags
```

### proof2signer

```solidity
mapping(string => address) proof2signer
```

### poauSignersIdx

```solidity
mapping(string => mapping(address => uint256)) poauSignersIdx
```

### NewProofOfAuthority

```solidity
event NewProofOfAuthority(struct DAOSignApp.SignedProofOfAuthority data)
```

### NewProofOfSignature

```solidity
event NewProofOfSignature(struct DAOSignApp.SignedProofOfSignature data)
```

### NewProofOfAgreement

```solidity
event NewProofOfAgreement(struct DAOSignApp.SignedProofOfAgreement data)
```

### SignedProofOfAuthority

```solidity
struct SignedProofOfAuthority {
  struct DAOSignEIP712.ProofOfAuthority message;
  bytes signature;
  string proofCID;
}
```

### SignedProofOfAuthorityMsg

```solidity
struct SignedProofOfAuthorityMsg {
  struct DAOSignEIP712.EIP712ProofOfAuthority message;
  bytes signature;
}
```

### SignedProofOfSignature

```solidity
struct SignedProofOfSignature {
  struct DAOSignEIP712.ProofOfSignature message;
  bytes signature;
  string proofCID;
}
```

### SignedProofOfSignatureMsg

```solidity
struct SignedProofOfSignatureMsg {
  struct DAOSignEIP712.EIP712ProofOfSignature message;
  bytes signature;
}
```

### SignedProofOfAgreement

```solidity
struct SignedProofOfAgreement {
  struct DAOSignEIP712.ProofOfAgreement message;
  bytes signature;
  string proofCID;
}
```

### SignedProofOfAgreementMsg

```solidity
struct SignedProofOfAgreementMsg {
  struct DAOSignEIP712.EIP712ProofOfAgreement message;
  bytes signature;
}
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
function validate(struct DAOSignApp.SignedProofOfAuthority data) internal pure returns (bool)
```

### validate

```solidity
function validate(struct DAOSignApp.SignedProofOfSignature data) internal view returns (bool)
```

### validate

```solidity
function validate(struct DAOSignApp.SignedProofOfAgreement data) internal view returns (bool)
```

### storeProofOfAuthority

```solidity
function storeProofOfAuthority(struct DAOSignApp.SignedProofOfAuthority data) external
```

### storeProofOfSignature

```solidity
function storeProofOfSignature(struct DAOSignApp.SignedProofOfSignature data) external
```

### storeProofOfAgreement

```solidity
function storeProofOfAgreement(struct DAOSignApp.SignedProofOfAgreement data) external
```

### getProofOfAuthority

```solidity
function getProofOfAuthority(string cid) external view returns (struct DAOSignApp.SignedProofOfAuthorityMsg)
```

### getProofOfSignature

```solidity
function getProofOfSignature(string cid) external view returns (struct DAOSignApp.SignedProofOfSignatureMsg)
```

### getProofOfAgreement

```solidity
function getProofOfAgreement(string cid) external view returns (struct DAOSignApp.SignedProofOfAgreementMsg)
```

