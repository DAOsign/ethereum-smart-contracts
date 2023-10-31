## ProofsVerification

Verifies Proof-of-Authority and Proof-of-Signature validity. May be used to verify any Ethereum
signature.

### verifySignedProof

```solidity
function verifySignedProof(address _signer, string _data, bytes _signature) public pure returns (bool)
```

Verify Proof-of-Authority or Proof-of-Signature signature

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _signer | address | Signer of the data |
| _data | string | Raw Proof-of-Authority stringified JSON object that the signer signs.              Note: it may be the output of Proofs.getProofOfSignatureData function |
| _signature | bytes | Signature of the {_data} |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bool | isValid Is signature valid or not |

### verify

```solidity
function verify(address _signer, bytes32 _dataHash, bytes _signature) public pure returns (bool)
```

Verify any Ethereum signature of any data

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _signer | address | Signer of the data |
| _dataHash | bytes32 | Hash of the data that was signed |
| _signature | bytes | Signature of the data |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bool | isValid Is signature valid or not |

