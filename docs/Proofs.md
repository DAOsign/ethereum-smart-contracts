## Proofs

Stores DAOsign proofs.

Note
Proof-of-Authority = PoAu
Proof-of-Signature = PoSi
Proof-of-Agreement = PoAg

### proofsMetadata

```solidity
address proofsMetadata
```

### signedProofs

```solidity
mapping(string => mapping(string => string)) signedProofs
```

### proofsData

```solidity
mapping(string => mapping(enum ProofTypes.Proofs => mapping(address => string))) proofsData
```

### ProofOfAuthority

```solidity
event ProofOfAuthority(address creator, bytes signature, string agreementFileCID, string proofCID, string proof)
```

### ProofOfSignature

```solidity
event ProofOfSignature(address signer, bytes signature, string agreementFileCID, string proofCID, string proof)
```

### constructor

```solidity
constructor(address _proofsMetadata) public
```

### fetchProofOfAuthorityData

```solidity
function fetchProofOfAuthorityData(address _creator, address[] _signers, string _agreementFileCID, string _version) public returns (string)
```

Public:
    - Create Proof-of-Authority data (given a creator's address, agreementFileCID, and the list of signers)
    - Create Proof-of-Signature (given a signer's address and Proof-of-Authority IPFS CID)
    - Sign (off-chain), store & verify signature of the data (used for any proof), generate proof IPFS CID

    System:
    - autogenereate Proof-of-Agreement

### fetchProofOfSignatureData

```solidity
function fetchProofOfSignatureData(address _signer, string _agreementFileCID, string _proofOfAuthorityCID, string _version) public returns (string)
```

### storeProofOfAuthority

```solidity
function storeProofOfAuthority(address _creator, bytes _signature, string _agreementFileCID, string _proofCID) public
```

### storeProofOfSignature

```solidity
function storeProofOfSignature(address _signer, bytes _signature, string _agreementFileCID, string _proofCID) public
```

### _getProofOfAuthorityOrSignature

```solidity
function _getProofOfAuthorityOrSignature(address _creator, bytes _signature, string _data) internal pure returns (string proof)
```

### _getProofOfAuthorityData

```solidity
function _getProofOfAuthorityData(address _creator, address[] _signers, string _agreementFileCID, string _version, uint256 _timestamp) internal view returns (string)
```

### _getProofOfSignatureData

```solidity
function _getProofOfSignatureData(address _signer, string _proofOfAuthorityCID, string _version, uint256 _timestamp) internal view returns (string)
```

### _getProofOfAuthorityDataMessage

```solidity
function _getProofOfAuthorityDataMessage(address _creator, address[] _signers, string _agreementFileCID, uint256 _timestamp) internal pure returns (string message)
```

### _getProofOfSignatureDataMessage

```solidity
function _getProofOfSignatureDataMessage(address _signer, string _proofOfAuthorityCID, uint256 _timestamp) internal pure returns (string message)
```

### _generateSignersJSON

```solidity
function _generateSignersJSON(address[] _signers) internal pure returns (string)
```

