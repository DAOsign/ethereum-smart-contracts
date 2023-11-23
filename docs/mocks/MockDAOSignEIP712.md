## MockDAOSignEIP712

### constructor

```solidity
constructor(struct DAOSignEIP712.EIP712Domain _domain) public
```

### getDomainHash

```solidity
function getDomainHash() public view returns (bytes32)
```

### getProofOfAuthorityMessage

```solidity
function getProofOfAuthorityMessage(struct DAOSignEIP712.ProofOfAuthority message) public view returns (struct DAOSignEIP712.EIP712ProofOfAuthority)
```

### getProofOfSignatureMessage

```solidity
function getProofOfSignatureMessage(struct DAOSignEIP712.ProofOfSignature message) public view returns (struct DAOSignEIP712.EIP712ProofOfSignature)
```

### getProofOfAgreementMessage

```solidity
function getProofOfAgreementMessage(struct DAOSignEIP712.ProofOfAgreement message) public view returns (struct DAOSignEIP712.EIP712ProofOfAgreement)
```

### hashProofOfAuthority

```solidity
function hashProofOfAuthority(struct DAOSignEIP712.ProofOfAuthority message) public pure returns (bytes32)
```

### hashProofOfSignature

```solidity
function hashProofOfSignature(struct DAOSignEIP712.ProofOfSignature message) public pure returns (bytes32)
```

### hashProofOfAgreement

```solidity
function hashProofOfAgreement(struct DAOSignEIP712.ProofOfAgreement message) public pure returns (bytes32)
```

### recoverProofOfAuthority

```solidity
function recoverProofOfAuthority(struct DAOSignEIP712.ProofOfAuthority message, bytes signature) public view returns (address)
```

### recoverProofOfSignature

```solidity
function recoverProofOfSignature(struct DAOSignEIP712.ProofOfSignature message, bytes signature) public view returns (address)
```

### recoverProofOfAgreement

```solidity
function recoverProofOfAgreement(struct DAOSignEIP712.ProofOfAgreement message, bytes signature) public view returns (address)
```

