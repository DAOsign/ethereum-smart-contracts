## DAOsignProofs

### proofs

```solidity
mapping(string => bytes) proofs
```

### validate

```solidity
function validate(struct Proofs.ProofOfAuthorityShrinked _proof) internal view returns (bool)
```

### validate

```solidity
function validate(struct Proofs.ProofOfSignatureShrinked _proof) internal view returns (bool)
```

### validate

```solidity
function validate(struct Proofs.ProofOfAgreement _proof) internal view returns (bool)
```

### save

```solidity
function save(struct Proofs.ProofOfAuthorityShrinked _proof, string _proofCID) internal
```

### save

```solidity
function save(struct Proofs.ProofOfSignatureShrinked _proof) internal
```

### save

```solidity
function save(struct Proofs.ProofOfAgreement _proof) internal
```

### getProofOfAuthority

```solidity
function getProofOfAuthority(string _proofCID) public view returns (struct Proofs.ProofOfAuthorityShrinked)
```

