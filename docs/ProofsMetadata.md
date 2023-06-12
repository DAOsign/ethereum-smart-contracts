## ProofsMetadata

### MetadataAdded

```solidity
event MetadataAdded(string name, string version, string metadata)
```

### MetadataUpdated

```solidity
event MetadataUpdated(string name, string version, string metadata)
```

### proofsMetadata

```solidity
mapping(string => mapping(string => string)) proofsMetadata
```

### metadataVersions

```solidity
mapping(string => string[]) metadataVersions
```

### getMetadataNumOfVersions

```solidity
function getMetadataNumOfVersions(string name) public view returns (uint256)
```

Get number of versions that exist for metadata by its name

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| name | string | Name of metadata. As for now, it's Proof-of-Authority, Proof-of-Signature, and             Proof-of-Agreement. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | numVersions Number of versions. |

### addMetadata

```solidity
function addMetadata(string name, string version, string metadata) public
```

Add metadata by the contract administrator.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| name | string | Name of metadata. As for now, it's Proof-of-Authority, Proof-of-Signature, and             Proof-of-Agreement. |
| version | string | Protocol version of the metadata. The version should be increased every time                there is a change in the metadata. |
| metadata | string | Metadata in JSON format. |

### forceUpdateMetadata

```solidity
function forceUpdateMetadata(string name, string version, string metadata) public
```

Update metadata by the contract administrator.
Note: This has to be done ONLY in the event of incorrect data entry in `addMetadata`
      function. Update of metadata on the protocol level should be done by adding another
      metadata with newer version.

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| name | string | Name of metadata. As for now, it's Proof-of-Authority, Proof-of-Signature, and             Proof-of-Agreement. |
| version | string | Protocol version of the metadata. The version should be increased every time                there is a change in the metadata. This function is only to adjusting the                inconsistency of metadata in smart contract and the one, used on the website. |
| metadata | string | Metadata in JSON format. |

