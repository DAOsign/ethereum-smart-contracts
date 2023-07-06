## IProofsMetadata

### MetadataAdded

```solidity
event MetadataAdded(enum ProofTypes.Proofs proof, string version, string metadata)
```

### MetadataUpdated

```solidity
event MetadataUpdated(enum ProofTypes.Proofs proof, string version, string metadata)
```

### proofsMetadata

```solidity
function proofsMetadata(enum ProofTypes.Proofs _type, string _version) external view returns (string)
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
function addMetadata(enum ProofTypes.Proofs _type, string _version, string _metadata) external
```

### forceUpdateMetadata

```solidity
function forceUpdateMetadata(enum ProofTypes.Proofs _type, string _version, string _metadata) external
```

