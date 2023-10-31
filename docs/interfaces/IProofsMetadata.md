## IProofsMetadata

### MetadataAdded

```solidity
event MetadataAdded(enum ProofTypes.Proofs proof, string version, bytes metadata)
```

### MetadataUpdated

```solidity
event MetadataUpdated(enum ProofTypes.Proofs proof, string version, bytes metadata)
```

### proofsMetadata

```solidity
function proofsMetadata(enum ProofTypes.Proofs _type, string _version) external view returns (bytes)
```

### metadataVersions

```solidity
function metadataVersions(enum ProofTypes.Proofs _type, uint256 index) external view returns (string)
```

### getMetadataNumOfVersions

```solidity
function getMetadataNumOfVersions(enum ProofTypes.Proofs _type) external view returns (uint256)
```

### addMetadata

```solidity
function addMetadata(enum ProofTypes.Proofs _type, string _version, bytes _metadata) external
```

### forceUpdateMetadata

```solidity
function forceUpdateMetadata(enum ProofTypes.Proofs _type, string _version, bytes _metadata) external
```

