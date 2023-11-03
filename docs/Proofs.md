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

### ProofOfAgreementMsg

```solidity
struct ProofOfAgreementMsg {
  string agreementFileProofCID;
  struct Proofs.AgreementSignProof[] agreementSignProofs;
  uint64 timestamp;
}
```

### ProofOfAgreementShrinked

```solidity
struct ProofOfAgreementShrinked {
  string version;
  struct Proofs.ProofOfSignatureMsg message;
}
```

### constructor

```solidity
constructor() internal
```

### hash

```solidity
function hash(struct Proofs.EIP712Domain _input) internal pure returns (bytes32)
```

### hash

```solidity
function hash(struct Proofs.Signer _input) internal pure returns (bytes32)
```

### hash

```solidity
function hash(struct Proofs.Signer[] _input) internal pure returns (bytes32)
```

### hash

```solidity
function hash(struct Proofs.ProofOfAuthorityMsg _input) internal pure returns (bytes32)
```

### hash

```solidity
function hash(struct Proofs.ProofOfSignatureMsg _input) internal pure returns (bytes32)
```

### hash

```solidity
function hash(struct Proofs.AgreementSignProof _input) internal pure returns (bytes32)
```

### hash

```solidity
function hash(struct Proofs.AgreementSignProof[] _input) internal pure returns (bytes32)
```

### hash

```solidity
function hash(struct Proofs.ProofOfAgreementMsg _input) internal pure returns (bytes32)
```

### recover

```solidity
function recover(struct Proofs.ProofOfAuthorityMsg message, bytes signature) public view returns (address)
```

### recover

```solidity
function recover(struct Proofs.ProofOfSignatureMsg message, bytes signature) public view returns (address)
```

### recover

```solidity
function recover(struct Proofs.ProofOfAgreementMsg message, bytes signature) public view returns (address)
```

### storeProofOfAuthority

```solidity
function storeProofOfAuthority(struct Proofs.ProofOfAuthorityShrinked _proof) public
```

### storeProofOfSignature

```solidity
function storeProofOfSignature(struct Proofs.ProofOfSignatureShrinked _proof) public
```

### storeProofOfAgreement

```solidity
function storeProofOfAgreement(struct Proofs.ProofOfAgreementShrinked _proof) public
```

### validate

```solidity
function validate(struct Proofs.ProofOfAuthorityShrinked) internal view virtual returns (bool)
```

### validate

```solidity
function validate(struct Proofs.ProofOfSignatureShrinked) internal view virtual returns (bool)
```

### validate

```solidity
function validate(struct Proofs.ProofOfAgreementShrinked) internal view virtual returns (bool)
```

### save

```solidity
function save(struct Proofs.ProofOfAuthorityShrinked) public virtual
```

### save

```solidity
function save(struct Proofs.ProofOfSignatureShrinked) public virtual
```

### save

```solidity
function save(struct Proofs.ProofOfAgreementShrinked) public virtual
```

### get

```solidity
function get(struct Proofs.ProofOfAuthorityMsg) public virtual returns (struct Proofs.ProofOfAuthorityShrinked)
```

