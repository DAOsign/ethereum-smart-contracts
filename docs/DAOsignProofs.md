## DAOsignProofs

### proofs

```solidity
mapping(string => bytes) proofs
```

### getProofOfAuthority

```solidity
function getProofOfAuthority(string _proofCID) public view returns (struct Proofs.ProofOfAuthorityShrinked)
```

### getProofOfSignature

```solidity
function getProofOfSignature(string _proofCID) public view returns (struct Proofs.ProofOfSignatureShrinked)
```

### getProofOfAgreement

```solidity
function getProofOfAgreement(string _proofCID) public view returns (struct Proofs.ProofOfAgreement)
```

### _validate

```solidity
function _validate(struct Proofs.ProofOfAuthorityShrinked _proof) internal view returns (bool)
```

### _validate

```solidity
function _validate(struct Proofs.ProofOfSignatureShrinked _proof) internal view returns (bool)
```

### _validate

```solidity
function _validate(struct Proofs.ProofOfAgreement _proof) internal view returns (bool)
```

### _store

```solidity
function _store(struct Proofs.ProofOfAuthorityShrinked _proof, string _proofCID) internal
```

### _store

```solidity
function _store(struct Proofs.ProofOfSignatureShrinked _proof, string _proofCID) internal
```

### _store

```solidity
function _store(struct Proofs.ProofOfAgreement _proof, string _proofCID) internal
```

