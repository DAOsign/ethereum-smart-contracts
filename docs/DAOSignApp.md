## DAOSignApp

### IPFS_CID_LENGTH

```solidity
uint256 IPFS_CID_LENGTH
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

