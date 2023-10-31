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

### poaData

```solidity
function poaData(bytes32 input) external view returns (string)
```

### posData

```solidity
function posData(bytes32 input) external view returns (string)
```

### poagData

```solidity
function poagData(bytes32 input) external view returns (string)
```

### fetchProofOfAuthorityData

```solidity
function fetchProofOfAuthorityData(address _creator, address[] _signers, string _agreementFileCID, string _version, bytes _dataSig) external returns (string)
```

Actual functions

### fetchProofOfSignatureData

```solidity
function fetchProofOfSignatureData(address _signer, string _agreementFileCID, string _proofOfAuthorityCID, string _version, bytes _dataSig) external returns (string)
```

### fetchProofOfAgreementData

```solidity
function fetchProofOfAgreementData(string _agreementFileCID, string _proofOfAuthorityCID, string[] _proofsOfSignatureCID) external returns (string)
```

### storeProofOfAuthority

```solidity
function storeProofOfAuthority(address _creator, address[] _signers, string _version, bytes _signature, string _fileCID, string _proofCID) external
```

### storeProofOfSignature

```solidity
function storeProofOfSignature(address _signer, bytes _signature, string _fileCID, string _posCID, string _poaCID, string _version) external
```

### storeProofOfAgreement

```solidity
function storeProofOfAgreement(string _fileCID, string _poaCID, string[] _posCIDs, string _poagCID) external
```

### getPoAData

```solidity
function getPoAData(address _creator, address[] _signers, string _fileCID, string _version) external view returns (string)
```

### getPoSData

```solidity
function getPoSData(address _signer, string _fileCID, string _poaCID, string _version) external view returns (string)
```

### getPoAgData

```solidity
function getPoAgData(string _fileCID, string _poaCID, string[] _posCIDs) external view returns (string)
```

