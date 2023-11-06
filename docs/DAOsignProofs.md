## DAOsignProofs

### initializeDAOsignProofs

```solidity
function initializeDAOsignProofs(address _owner) public
```

### getProofOfAuthority

```solidity
function getProofOfAuthority(string _proofCID) external view returns (struct Proofs.ProofOfAuthorityShrinked)
```

### getProofOfSignature

```solidity
function getProofOfSignature(string _proofCID) external view returns (struct Proofs.ProofOfSignatureShrinked)
```

### getProofOfAgreement

```solidity
function getProofOfAgreement(string _proofCID) external view returns (struct Proofs.ProofOfAgreement)
```

### storeProofOfAuthority

```solidity
function storeProofOfAuthority(struct Proofs.ProofOfAuthorityShrinked _proof, string _proofCID) external
```

### storeProofOfSignature

```solidity
function storeProofOfSignature(struct Proofs.ProofOfSignatureShrinked _proof, string _proofCID) external
```

### storeProofOfAgreement

```solidity
function storeProofOfAgreement(struct Proofs.ProofOfAgreement _proof, string _proofCID) external
```

