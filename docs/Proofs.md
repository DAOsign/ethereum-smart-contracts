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

### proofsData

```solidity
mapping(string => mapping(enum ProofTypes.Proofs => mapping(address => string))) proofsData
```

### constructor

```solidity
constructor(address _proofsMetadata) public
```

### fetchProofOfAuthorityData

```solidity
function fetchProofOfAuthorityData(address _creator, address[] _signers, string _agreementFileCID, string _version) public returns (string)
```

Generates Proof-of-Authority data for creator to sign and caches it in the smart contract
memory

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _creator | address | Agreement creator address |
| _signers | address[] | Array of signers of the agreement |
| _agreementFileCID | string | IPFS CID of the agreement file |
| _version | string | EIP712 version of the data |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | string | proofData Proof-of-Authority data to sign |

### fetchProofOfSignatureData

```solidity
function fetchProofOfSignatureData(address _signer, string _agreementFileCID, string _proofOfAuthorityCID, string _version) public returns (string)
```

Generates Proof-of-Signature data for creator to sign and caches it in the smart contract
memory

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _signer | address | Current signer of the agreement from the list of agreement signers |
| _agreementFileCID | string | IPFS CID of the agreement file |
| _proofOfAuthorityCID | string | IPFS CID of Proof-of-Authority |
| _version | string | EIP712 version of the data |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | string | proofData Proof-of-Signature data to sign |

### fetchProofOfAgreementData

```solidity
function fetchProofOfAgreementData(string _agreementFileCID, string _proofOfAuthorityCID, string[] _proofsOfSignatureCID) public returns (string)
```

Generates Proof-of-Agreement data for creator to sign and caches it in the smart contract
memory

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _agreementFileCID | string | IPFS CID of the agreement file |
| _proofOfAuthorityCID | string | IPFS CID of Proof-of-Authority |
| _proofsOfSignatureCID | string[] | IPFS CID of Proof-of-Signature |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | string | proofData Proof-of-Agreement data to sign |

### storeProofOfAuthority

```solidity
function storeProofOfAuthority(address _creator, bytes _signature, string _agreementFileCID, string _proofCID) public
```

Stores Proof-of-Authority after verifying the correctness of the signature

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _creator | address | Agreement creator address |
| _signature | bytes | Signature of Proof-of-Authority data |
| _agreementFileCID | string | IPFS CID of the agreement file |
| _proofCID | string | IPFS CID of Proof-of-Authority |

### storeProofOfSignature

```solidity
function storeProofOfSignature(address _signer, bytes _signature, string _agreementFileCID, string _proofCID) public
```

Stores Proof-of-Signature after verifying the correctness of the signature

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _signer | address | Current signer of the agreement from the list of agreement signers |
| _signature | bytes | Signature of Proof-of-Signature data |
| _agreementFileCID | string | IPFS CID of the agreement file |
| _proofCID | string | IPFS CID of Proof-of-Signature |

### storeProofOfAgreement

```solidity
function storeProofOfAgreement(string _agreementFileCID, string _proofOfAuthorityCID, string _proofCID) public
```

Stores Proof-of-Agreement

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _agreementFileCID | string | IPFS CID of the agreement file |
| _proofOfAuthorityCID | string | IPFS CID of Proof-of-Authority |
| _proofCID | string | IPFS CID of Proof-of-Agreement |

