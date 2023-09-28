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

Actual functions

### fetchProofOfSignatureData

```solidity
function fetchProofOfSignatureData(address _signer, string _agreementFileCID, string _proofOfAuthorityCID, string _version) public returns (string)
```

### fetchProofOfAgreementData

```solidity
function fetchProofOfAgreementData(string _agreementFileCID, string _proofOfAuthorityCID, string[] _proofsOfSignatureCID) public returns (string)
```

### storeProofOfAuthority

```solidity
function storeProofOfAuthority(address _creator, bytes _signature, string _agreementFileCID, string _proofCID) public
```

### storeProofOfSignature

```solidity
function storeProofOfSignature(address _signer, bytes _signature, string _agreementFileCID, string _proofCID) public
```

### storeProofOfAgreement

```solidity
function storeProofOfAgreement(string _agreementFileCID, string _proofOfAuthorityCID, string _proofCID) public
```

