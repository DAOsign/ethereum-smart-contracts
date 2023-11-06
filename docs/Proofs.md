## Proofs

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

### EIP712Domain

```solidity
struct EIP712Domain {
  string name;
  string version;
}
```

### Signer

```solidity
struct Signer {
  address addr;
  string metadata;
}
```

### ProofOfAuthorityMsg

```solidity
struct ProofOfAuthorityMsg {
  string name;
  address from;
  string agreementFileCID;
  struct Proofs.Signer[] signers;
  string app;
  uint64 timestamp;
  string metadata;
}
```

### ProofOfAuthorityShrinked

```solidity
struct ProofOfAuthorityShrinked {
  bytes sig;
  string version;
  struct Proofs.ProofOfAuthorityMsg message;
}
```

### ProofOfSignatureMsg

```solidity
struct ProofOfSignatureMsg {
  string name;
  address signer;
  string agreementFileProofCID;
  string app;
  uint64 timestamp;
  string metadata;
}
```

### ProofOfSignatureShrinked

```solidity
struct ProofOfSignatureShrinked {
  bytes sig;
  string version;
  struct Proofs.ProofOfSignatureMsg message;
}
```

### AgreementSignProof

```solidity
struct AgreementSignProof {
  string proofCID;
}
```

### ProofOfAgreement

```solidity
struct ProofOfAgreement {
  string agreementFileProofCID;
  struct Proofs.AgreementSignProof[] agreementSignProofs;
  uint64 timestamp;
  string metadata;
}
```

### NewProofOfAuthority

```solidity
event NewProofOfAuthority(struct Proofs.ProofOfAuthorityShrinked proof)
```

### NewProofOfSignature

```solidity
event NewProofOfSignature(struct Proofs.ProofOfSignatureShrinked proof)
```

### NewProofOfAgreement

```solidity
event NewProofOfAgreement(struct Proofs.ProofOfAgreement proof)
```

### DomainHashUpdated

```solidity
event DomainHashUpdated(struct Proofs.EIP712Domain domain)
```

### EIP712DomainTypeHashUpdated

```solidity
event EIP712DomainTypeHashUpdated(string eip712DomainTypeHash)
```

### SignerTypeHashUpdated

```solidity
event SignerTypeHashUpdated(string signerTypeHash)
```

### ProofAuthorityTypeHashUpdated

```solidity
event ProofAuthorityTypeHashUpdated(string proofAuthorityTypeHash)
```

### ProofSignatureTypeHashUpdated

```solidity
event ProofSignatureTypeHashUpdated(string proofSignatureTypeHash)
```

### AgrSignProofTypeHashUpdated

```solidity
event AgrSignProofTypeHashUpdated(string agrSignProofTypeHash)
```

### ProofAgreementTypeHashUpdated

```solidity
event ProofAgreementTypeHashUpdated(string proofAgreementTypeHash)
```

### initialize

```solidity
function initialize(address _owner) public
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
function _validate(struct Proofs.ProofOfAuthorityShrinked) internal view virtual returns (bool)
```

### _validate

```solidity
function _validate(struct Proofs.ProofOfSignatureShrinked) internal view virtual returns (bool)
```

### _validate

```solidity
function _validate(struct Proofs.ProofOfAgreement) internal view virtual returns (bool)
```

### _store

```solidity
function _store(struct Proofs.ProofOfAuthorityShrinked, string) internal virtual
```

### _store

```solidity
function _store(struct Proofs.ProofOfSignatureShrinked, string) internal virtual
```

### _store

```solidity
function _store(struct Proofs.ProofOfAgreement, string) internal virtual
```

### getProofOfAuthority

```solidity
function getProofOfAuthority(string) public virtual returns (struct Proofs.ProofOfAuthorityShrinked)
```

### getProofOfSignature

```solidity
function getProofOfSignature(string) public virtual returns (struct Proofs.ProofOfSignatureShrinked)
```

### getProofOfAgreement

```solidity
function getProofOfAgreement(string) public virtual returns (struct Proofs.ProofOfAgreement)
```

