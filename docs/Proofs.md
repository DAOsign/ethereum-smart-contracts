## Proofs

Stores DAOsign proofs.

Note
Proof-of-Authority = PoA
Proof-of-Signature = PoS
Proof-of-Agreement = PoAg

### proofsMetadata

```solidity
address proofsMetadata
```

Functions from variables

### finalProofs

```solidity
mapping(string => mapping(string => string)) finalProofs
```

### poaData

```solidity
mapping(bytes32 => string) poaData
```

### posData

```solidity
mapping(bytes32 => string) posData
```

### poagData

```solidity
mapping(bytes32 => string) poagData
```

### constructor

```solidity
constructor(address _proofsMetadata, address _admin) public
```

### fetchProofOfAuthorityData

```solidity
function fetchProofOfAuthorityData(address _creator, address[] _signers, string _fileCID, string _version, bytes _dataSig) external returns (string)
```

Generates Proof-of-Authority data for creator to sign and caches it in the smart contract
memory

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _creator | address | Agreement creator address |
| _signers | address[] | Array of signers of the agreement |
| _fileCID | string | IPFS CID of the agreement file |
| _version | string | EIP712 version of the data |
| _dataSig | bytes | _creator's signature of all input parameters to make sure they are correct |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | string | proofData Proof-of-Authority data to sign |

### fetchProofOfSignatureData

```solidity
function fetchProofOfSignatureData(address _signer, string _fileCID, string _poaCID, string _version, bytes _dataSig) external returns (string)
```

Generates Proof-of-Signature data for creator to sign and caches it in the smart contract
memory

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _signer | address | Current signer of the agreement from the list of agreement signers |
| _fileCID | string | IPFS CID of the agreement file |
| _poaCID | string | IPFS CID of Proof-of-Authority |
| _version | string | EIP712 version of the data |
| _dataSig | bytes |  |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | string | proofData Proof-of-Signature data to sign |

### fetchProofOfAgreementData

```solidity
function fetchProofOfAgreementData(string _fileCID, string _poaCID, string[] _posCID) external returns (string)
```

Generates Proof-of-Agreement data for creator to sign and caches it in the smart contract
memory

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _fileCID | string | IPFS CID of the agreement file |
| _poaCID | string | IPFS CID of Proof-of-Authority |
| _posCID | string[] | IPFS CID of Proof-of-Signature |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | string | proofData Proof-of-Agreement data to sign |

### storeProofOfAuthority

```solidity
function storeProofOfAuthority(address _creator, address[] _signers, string _version, bytes _signature, string _fileCID, string _proofCID) external
```

Stores Proof-of-Authority after verifying the correctness of the signature

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _creator | address | Agreement creator address |
| _signers | address[] | List of signer addresses |
| _version | string |  |
| _signature | bytes | Signature of Proof-of-Authority data |
| _fileCID | string | IPFS CID of the agreement file |
| _proofCID | string | IPFS CID of Proof-of-Authority |

### storeProofOfSignature

```solidity
function storeProofOfSignature(address _signer, bytes _signature, string _fileCID, string _posCID, string _poaCID, string _version) external
```

Stores Proof-of-Signature after verifying the correctness of the signature

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _signer | address | Current signer of the agreement from the list of agreement signers |
| _signature | bytes | Signature of Proof-of-Signature data |
| _fileCID | string | IPFS CID of the agreement file |
| _posCID | string | IPFS CID of Proof-of-Signature |
| _poaCID | string |  |
| _version | string |  |

### storeProofOfAgreement

```solidity
function storeProofOfAgreement(string _fileCID, string _poaCID, string[] _posCIDs, string _poagCID) external
```

Stores Proof-of-Agreement

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _fileCID | string | IPFS CID of the agreement file |
| _poaCID | string | IPFS CID of Proof-of-Authority |
| _posCIDs | string[] | IPFS CIDs of Proof-of-Signature |
| _poagCID | string | IPFS CID of Proof-of-Agreement |

### getPoAData

```solidity
function getPoAData(address _creator, address[] _signers, string _fileCID, string _version) public view returns (string)
```

### getPoSData

```solidity
function getPoSData(address _signer, string _fileCID, string _poaCID, string _version) public view returns (string)
```

### getPoAgData

```solidity
function getPoAgData(string _fileCID, string _poaCID, string[] _posCIDs) public view returns (string)
```

### _setPoAData

```solidity
function _setPoAData(address _creator, address[] _signers, string _fileCID, string _version, string _data) internal
```

### _setPoSData

```solidity
function _setPoSData(address _signer, string _fileCID, string _poaCID, string _version, string _data) internal
```

### _setPoAgData

```solidity
function _setPoAgData(string _fileCID, string _poaCID, string[] _posCID, string _data) internal
```

