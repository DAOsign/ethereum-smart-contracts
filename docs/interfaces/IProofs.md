## IProofs

### NewProofOfAuthority

```solidity
event NewProofOfAuthority(struct IProofs.ProofOfAuthorityMsg message)
```

### ProofOfSignatureEvent

```solidity
event ProofOfSignatureEvent(address signer, bytes signature, string agreementFileCID, string proofCID, string proofJSON)
```

### ProofOfAgreementEvent

```solidity
event ProofOfAgreementEvent(string agreementFileCID, string proofOfAuthorityCID, string proofCID, string proofJSON)
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
  struct IProofs.Signer[] signers;
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
  struct IProofs.ProofOfAuthorityMsg message;
}
```

