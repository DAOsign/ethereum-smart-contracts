## Proofs

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
event NewProofOfAuthority(struct Proofs.ProofOfAuthorityShrinked proof, string proofCID)
```

### NewProofOfSignature

```solidity
event NewProofOfSignature(struct Proofs.ProofOfSignatureShrinked proof, string proofCID)
```

### NewProofOfAgreement

```solidity
event NewProofOfAgreement(struct Proofs.ProofOfAgreement proof, string proofCID)
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

### _recover

```solidity
function _recover(struct Proofs.ProofOfAuthorityMsg message, bytes signature) public view virtual returns (address)
```

### _recover

```solidity
function _recover(struct Proofs.ProofOfSignatureMsg message, bytes signature) public view virtual returns (address)
```

### _hash

```solidity
function _hash(struct Proofs.EIP712Domain _input) internal view virtual returns (bytes32)
```

### _hash

```solidity
function _hash(struct Proofs.Signer _input) internal view virtual returns (bytes32)
```

### _hash

```solidity
function _hash(struct Proofs.Signer[] _input) internal view virtual returns (bytes32)
```

### _hash

```solidity
function _hash(struct Proofs.ProofOfAuthorityMsg _input) internal view virtual returns (bytes32)
```

### _hash

```solidity
function _hash(struct Proofs.ProofOfSignatureMsg _input) internal view virtual returns (bytes32)
```

### _hash

```solidity
function _hash(struct Proofs.AgreementSignProof _input) internal view virtual returns (bytes32)
```

### _hash

```solidity
function _hash(struct Proofs.AgreementSignProof[] _input) internal view virtual returns (bytes32)
```

### _hash

```solidity
function _hash(struct Proofs.ProofOfAgreement _input) internal view virtual returns (bytes32)
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

