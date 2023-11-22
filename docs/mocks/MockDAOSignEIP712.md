## MockDAOSignEIP712

### constructor

```solidity
constructor(struct EIP712Domain _domain) public
```

### getDomainHash

```solidity
function getDomainHash() public view returns (bytes32)
```

### getProofOfAuthorityMessage

```solidity
function getProofOfAuthorityMessage(struct ProofOfAuthority message) public view returns (struct EIP712ProofOfAuthority)
```

### getProofOfSignatureMessage

```solidity
function getProofOfSignatureMessage(struct ProofOfSignature message) public view returns (struct EIP712ProofOfSignature)
```

### getProofOfAgreementMessage

```solidity
function getProofOfAgreementMessage(struct ProofOfAgreement message) public view returns (struct EIP712ProofOfAgreement)
```

### hashProofOfAuthority

```solidity
function hashProofOfAuthority(struct ProofOfAuthority message) public pure returns (bytes32)
```

### hashProofOfSignature

```solidity
function hashProofOfSignature(struct ProofOfSignature message) public pure returns (bytes32)
```

### hashProofOfAgreement

```solidity
function hashProofOfAgreement(struct ProofOfAgreement message) public pure returns (bytes32)
```

### recoverProofOfAuthority

```solidity
function recoverProofOfAuthority(struct ProofOfAuthority message, bytes signature) public view returns (address)
```

### recoverProofOfSignature

```solidity
function recoverProofOfSignature(struct ProofOfSignature message, bytes signature) public view returns (address)
```

### recoverProofOfAgreement

```solidity
function recoverProofOfAgreement(struct ProofOfAgreement message, bytes signature) public view returns (address)
```

