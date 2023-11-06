## ProofsBase

### proofs

```solidity
mapping(string => bytes) proofs
```

### EIP712DOMAIN_TYPEHASH

```solidity
bytes32 EIP712DOMAIN_TYPEHASH
```

### SIGNER_TYPEHASH

```solidity
bytes32 SIGNER_TYPEHASH
```

### PROOF_AUTHORITY_TYPEHASH

```solidity
bytes32 PROOF_AUTHORITY_TYPEHASH
```

### PROOF_SIGNATURE_TYPEHASH

```solidity
bytes32 PROOF_SIGNATURE_TYPEHASH
```

### AGR_SIGN_PROOF_TYPEHASH

```solidity
bytes32 AGR_SIGN_PROOF_TYPEHASH
```

### PROOF_AGREEMENT_TYPEHASH

```solidity
bytes32 PROOF_AGREEMENT_TYPEHASH
```

### DOMAIN_HASH

```solidity
bytes32 DOMAIN_HASH
```

### initializeProofsBase

```solidity
function initializeProofsBase(address _owner) public
```

### updateDomainHash

```solidity
function updateDomainHash(struct Proofs.EIP712Domain _domain) external
```

### updateEIP712DomainTypeHash

```solidity
function updateEIP712DomainTypeHash(string _eip712Domain) external
```

### updateSignerTypeHash

```solidity
function updateSignerTypeHash(string _signerType) external
```

### updateProofAuthorityTypeHash

```solidity
function updateProofAuthorityTypeHash(string _proofAuthorityType) external
```

### updateProofSignatureTypeHash

```solidity
function updateProofSignatureTypeHash(string _proofSignatureType) external
```

### updateAgrSignProofTypeHash

```solidity
function updateAgrSignProofTypeHash(string _agrSignProofType) external
```

### updateProofAgreementTypeHash

```solidity
function updateProofAgreementTypeHash(string _proofAgreementType) external
```

### recover

```solidity
function recover(struct Proofs.ProofOfAuthorityMsg message, bytes signature) public view returns (address)
```

### recover

```solidity
function recover(struct Proofs.ProofOfSignatureMsg message, bytes signature) public view returns (address)
```

### hash

```solidity
function hash(struct Proofs.EIP712Domain _input) internal view returns (bytes32)
```

### hash

```solidity
function hash(struct Proofs.Signer _input) internal view returns (bytes32)
```

### hash

```solidity
function hash(struct Proofs.Signer[] _input) internal view returns (bytes32)
```

### hash

```solidity
function hash(struct Proofs.ProofOfAuthorityMsg _input) internal view returns (bytes32)
```

### hash

```solidity
function hash(struct Proofs.ProofOfSignatureMsg _input) internal view returns (bytes32)
```

### hash

```solidity
function hash(struct Proofs.AgreementSignProof _input) internal view returns (bytes32)
```

### hash

```solidity
function hash(struct Proofs.AgreementSignProof[] _input) internal view returns (bytes32)
```

### hash

```solidity
function hash(struct Proofs.ProofOfAgreement _input) internal view returns (bytes32)
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

