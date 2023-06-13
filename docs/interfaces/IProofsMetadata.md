## IProofsMetadata

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
function proofsMetadata(string name, string version) external view returns (string)
```

### metadataVersions

```solidity
function metadataVersions(string name, uint256 index) external view returns (string)
```

### getMetadataNumOfVersions

```solidity
function getMetadataNumOfVersions(string name) external view returns (uint256)
```

### addMetadata

```solidity
function addMetadata(string name, string version, string metadata) external
```

### forceUpdateMetadata

```solidity
function forceUpdateMetadata(string name, string version, string metadata) external
```

