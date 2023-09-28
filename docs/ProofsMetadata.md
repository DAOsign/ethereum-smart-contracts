## ProofsMetadata

Stores metadata for Proof-of-Authority, Proof-of-Signature, Proof-of-Agreement. Has an owner who
can update this metadata.

### proofsMetadata

```solidity
mapping(enum ProofTypes.Proofs => mapping(string => bytes)) proofsMetadata
```

### metadataVersions

```solidity
mapping(enum ProofTypes.Proofs => string[]) metadataVersions
```

### supportsInterface

```solidity
function supportsInterface(bytes4 interfaceId) public view virtual returns (bool)
```

_See {IERC165-supportsInterface}._

### getMetadataNumOfVersions

```solidity
function getMetadataNumOfVersions(enum ProofTypes.Proofs _type) public view returns (uint256)
```

Get number of versions that exist for metadata by its name

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _type | enum ProofTypes.Proofs | Type of the proof metadata. Declared in {ProofTypes} library |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | numVersions Number of versions. |

### addMetadata

```solidity
function addMetadata(enum ProofTypes.Proofs _type, string _version, bytes _metadata) public
```

Add metadata by the contract administrator.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _type | enum ProofTypes.Proofs | Type of the proof metadata. Declared in {ProofTypes} library |
| _version | string | Protocol version of the metadata. The version should be increased every time                there is a change in the metadata. |
| _metadata | bytes | Metadata in JSON format. |

### forceUpdateMetadata

```solidity
function forceUpdateMetadata(enum ProofTypes.Proofs _type, string _version, bytes _metadata) public
```

Update metadata by the contract administrator.
Note: This has to be done ONLY in the event of incorrect data entry in `addMetadata`
      function. Update of metadata on the protocol level should be done by adding another
      metadata with newer version.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _type | enum ProofTypes.Proofs | Type of the proof metadata. Declared in {ProofTypes} library |
| _version | string | Protocol version of the metadata. The version should be increased every time                there is a change in the metadata. This function is only to adjusting the                inconsistency of metadata in smart contract and the one, used on the website. |
| _metadata | bytes | Metadata in JSON format. |

