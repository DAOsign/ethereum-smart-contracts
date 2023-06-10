## ProofsMetadata

### MetadataAdded

```solidity
event MetadataAdded(string name, string version, string metadata)
```

### MetadataEdited

```solidity
event MetadataEdited(string name, string version, string metadata)
```

### proofsMetadata

```solidity
mapping(string => mapping(string => string)) proofsMetadata
```

### metadataVersions

```solidity
mapping(string => string[]) metadataVersions
```

### addMetadata

```solidity
function addMetadata(string name, string version, string metadata) public
```

### updateMetadata

```solidity
function updateMetadata(string name, string version, string metadata) public
```

