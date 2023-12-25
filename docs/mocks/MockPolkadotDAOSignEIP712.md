## MockPolkadotDAOSignEIP712

### constructor

```solidity
constructor(struct EIP712Domain _domain) public
```

### hash

```solidity
function hash(struct ProofOfAuthority data) internal pure returns (bytes32)
```

### hash

```solidity
function hash(struct ProofOfSignature data) internal pure returns (bytes32)
```

### hash

```solidity
function hash(struct ProofOfAgreement data) internal pure returns (bytes32)
```

### recover

```solidity
function recover(struct ProofOfAuthority data, bytes signature) internal view returns (address)
```

### recover

```solidity
function recover(struct ProofOfSignature data, bytes signature) internal view returns (address)
```

### recover

```solidity
function recover(struct ProofOfAgreement data, bytes signature) internal view returns (address)
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

