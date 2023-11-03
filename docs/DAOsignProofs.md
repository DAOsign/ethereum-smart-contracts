## DAOsignProofs

### proofs

```solidity
mapping(bytes32 => bytes) proofs
```

### myProofKeys

```solidity
mapping(address => bytes32[]) myProofKeys
```

### validate

```solidity
function validate(struct Proofs.ProofOfAuthorityShrinked _data) internal view returns (bool)
```

### validate

```solidity
function validate(struct Proofs.ProofOfSignatureShrinked _data) internal view returns (bool)
```

### validate

```solidity
function validate(struct Proofs.ProofOfAgreementShrinked) internal pure returns (bool)
```

### save

```solidity
function save(struct Proofs.ProofOfAuthorityShrinked _proof) public
```

### save

```solidity
function save(struct Proofs.ProofOfSignatureShrinked message) public
```

### save

```solidity
function save(struct Proofs.ProofOfAgreementShrinked message) public
```

### myProofKeysLen

```solidity
function myProofKeysLen(address _addr) public view returns (uint256)
```

### get

```solidity
function get(struct Proofs.ProofOfAuthorityMsg message) public view returns (struct Proofs.ProofOfAuthorityShrinked)
```

### getLastProofOfAuthority

```solidity
function getLastProofOfAuthority(address _addr) external view returns (struct Proofs.ProofOfAuthorityShrinked _proof)
```

