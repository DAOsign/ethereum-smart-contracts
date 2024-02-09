## MockDAOSignEIP712

### domain

```solidity
struct EIP712Domain domain
```

### domainHash

```solidity
bytes32 domainHash
```

### proofOfAuthority

```solidity
contract IEIP721ProofOfAuthority proofOfAuthority
```

### proofOfSignature

```solidity
contract IEIP712ProofOfSignature proofOfSignature
```

### proofOfAgreement

```solidity
contract IEIP712ProofOfAgreement proofOfAgreement
```

### proofOfVoid

```solidity
contract IEIP712ProofOfVoid proofOfVoid
```

### constructor

```solidity
constructor(struct EIP712Domain _domain, address _proofOfAuthority, address _proofOfSignature, address _proofOfAgreement, address _proofOfVoid) public
```

### getDomainHash

```solidity
function getDomainHash() public view returns (bytes32)
```

### getProofOfAuthorityMessage

```solidity
function getProofOfAuthorityMessage(struct ProofOfAuthority message) public view returns (struct EIP712ProofOfAuthorityDocument)
```

### getProofOfSignatureMessage

```solidity
function getProofOfSignatureMessage(struct ProofOfSignature message) public view returns (struct EIP712ProofOfSignatureDocument)
```

### getProofOfAgreementMessage

```solidity
function getProofOfAgreementMessage(struct ProofOfAgreement message) public view returns (struct EIP712ProofOfAgreementDocument)
```

### getProofOfVoidtMessage

```solidity
function getProofOfVoidtMessage(struct ProofOfVoid message) public view returns (struct EIP712ProofOfVoidDocument)
```

### hashProofOfAuthority

```solidity
function hashProofOfAuthority(struct ProofOfAuthority message) public view returns (bytes32)
```

### hashProofOfSignature

```solidity
function hashProofOfSignature(struct ProofOfSignature message) public view returns (bytes32)
```

### hashProofOfAgreement

```solidity
function hashProofOfAgreement(struct ProofOfAgreement message) public view returns (bytes32)
```

### hashProofOfVoid

```solidity
function hashProofOfVoid(struct ProofOfVoid message) public view returns (bytes32)
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

### recoverProofOfVoid

```solidity
function recoverProofOfVoid(struct ProofOfVoid message, bytes signature) public view returns (address)
```

