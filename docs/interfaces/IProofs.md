## IProofs

### ProofOfAuthority

```solidity
event ProofOfAuthority(address creator, bytes signature, string agreementFileCID, string proofCID, string proofJSON)
```

### ProofOfSignature

```solidity
event ProofOfSignature(address signer, bytes signature, string agreementFileCID, string proofCID, string proofJSON)
```

### ProofOfAgreement

```solidity
event ProofOfAgreement(string agreementFileCID, string proofOfAuthorityCID, string proofCID, string proofJSON)
```

### proofsMetadata

```solidity
function proofsMetadata() external view returns (address)
```

Functions from variables

### finalProofs

```solidity
function finalProofs(string agreementFileCID, string proofCID) external view returns (string)
```

### proofsData

```solidity
function proofsData(string agreementFileCID, enum ProofTypes.Proofs proofType, address signer) external view returns (string)
```

### fetchProofOfAuthorityData

```solidity
function fetchProofOfAuthorityData(address _creator, address[] _signers, string _agreementFileCID, string _version) external returns (string)
```

Actual functions

### fetchProofOfSignatureData

```solidity
function fetchProofOfSignatureData(address _signer, string _agreementFileCID, string _proofOfAuthorityCID, string _version) external returns (string)
```

### fetchProofOfAgreementData

```solidity
function fetchProofOfAgreementData(string _agreementFileCID, string _proofOfAuthorityCID, string[] _proofsOfSignatureCID) external returns (string)
```

### storeProofOfAuthority

```solidity
function storeProofOfAuthority(address _creator, bytes _signature, string _agreementFileCID, string _proofCID) external
```

### storeProofOfSignature

```solidity
function storeProofOfSignature(address _signer, bytes _signature, string _agreementFileCID, string _proofCID) external
```

### storeProofOfAgreement

```solidity
function storeProofOfAgreement(string _agreementFileCID, string _proofOfAuthorityCID, string _proofCID) external
```

