## ProofsHelper

ProofsHelper library helps Proofs smart contract to generate Proof-of-Authority, Proof-of-Signature, and
Proof-of-Agreement in a text format

### getProofOfAuthorityOrSignature

```solidity
function getProofOfAuthorityOrSignature(address _creator, bytes _signature, string _data) external pure returns (string _proof)
```

Returns full Proof-of-Authority or Proof-of-Signature (data with signature)

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _creator | address | Creator of the proof |
| _signature | bytes | Signature of the proof data |
| _data | string | Data that the user have signed |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| _proof | string | The proof object as a string |

### getProofOfAuthorityData

```solidity
function getProofOfAuthorityData(address _proofsMetadata, address _creator, address[] _signers, string _agreementFileCID, string _version, uint256 _timestamp) external view returns (string)
```

Returns Proof-of-Authority data for the creator to sign

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _proofsMetadata | address | EIP712 part of the proof data defined in ProofsMetadata smart contract |
| _creator | address | Creator of the agreement |
| _signers | address[] | Signers of the agreement |
| _agreementFileCID | string | IPFS CID of the agreement file |
| _version | string | EIP712 version of the data |
| _timestamp | uint256 | Timestamp of the proof |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | string | data Proof-of-Authority data |

### getProofOfSignatureData

```solidity
function getProofOfSignatureData(address _proofsMetadata, address _signer, string _proofOfAuthorityCID, string _version, uint256 _timestamp) external view returns (string)
```

Returns Proof-of-Signature data for the signer to sign

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _proofsMetadata | address | EIP712 part of the proof data defined in ProofsMetadata smart contract |
| _signer | address | Current signer of the agreement from the list of agreement signers |
| _proofOfAuthorityCID | string | IPFS CID of the Proof-of-Authority |
| _version | string | EIP712 version of the data |
| _timestamp | uint256 | Timestamp of the proof |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | string | data Proof-of-Signature data |

### getProofOfAgreementData

```solidity
function getProofOfAgreementData(string _proofOfAuthorityCID, string[] _proofsOfSignatureCID, uint256 _timestamp) external pure returns (string)
```

Returns Proof-of-Agreement data that is equal to Proof-of-Agreement as it requires no
signature

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _proofOfAuthorityCID | string | IPFS CID of the Proof-of-Authority |
| _proofsOfSignatureCID | string[] | Array of IPFS CID of every Proof-of-Signature from the agreement |
| _timestamp | uint256 | Timestamp of the proof |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | string | data Proof-of-Agreement data |

### getProofOfAuthorityDataMessage

```solidity
function getProofOfAuthorityDataMessage(address _creator, address[] _signers, string _agreementFileCID, uint256 _timestamp) public pure returns (string _message)
```

Returns the core message (without EIP712 metadata) of Proof-of-Authority for the creator to
sign

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _creator | address | Agreement creator address |
| _signers | address[] | Array of signers of the agreement |
| _agreementFileCID | string | IPFS CID of the agreement file |
| _timestamp | uint256 |  |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| _message | string | Proof-of-Authority message to sign |

### getProofOfSignatureDataMessage

```solidity
function getProofOfSignatureDataMessage(address _signer, string _proofOfAuthorityCID, uint256 _timestamp) public pure returns (string _message)
```

Returns the core message (without EIP712 metadata) of Proof-of-Signature for the signer to
sign

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _signer | address | Current signer of the agreement from the list of agreement signers |
| _proofOfAuthorityCID | string | IPFS CID of the Proof-of-Authority |
| _timestamp | uint256 | Timestamp of the proof |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| _message | string | Proof-of-Authority message to sign |

### generateSignersJSON

```solidity
function generateSignersJSON(address[] _signers) public pure returns (string)
```

Generates a JSON stringified content with signers of the agreement

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _signers | address[] | Array of signers of the agreement |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | string | res JSON stringified list of signers |

