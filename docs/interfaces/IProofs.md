## IProofs

### ProofOfAuthorityEvent

```solidity
event ProofOfAuthorityEvent(address creator, bytes signature, string agreementFileCID, string proofCID, string proofJSON)
```

### ProofOfSignatureEvent

```solidity
event ProofOfSignatureEvent(address signer, bytes signature, string agreementFileCID, string proofCID, string proofJSON)
```

### ProofOfAgreementEvent

```solidity
event ProofOfAgreementEvent(string agreementFileCID, string proofOfAuthorityCID, string proofCID, string proofJSON)
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

### storeProofOfAuthority

```solidity
function storeProofOfAuthority(address _creator, address[] _signers, string _version, bytes _signature, string _fileCID, string _proofCID) external
```

Actual functions

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

