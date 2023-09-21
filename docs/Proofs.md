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

### finalProofs

```solidity
mapping(string => mapping(string => string)) finalProofs
```

### proofsData

```solidity
mapping(string => mapping(enum ProofTypes.Proofs => mapping(address => string))) proofsData
```

### ProofOfAuthority

```solidity
event ProofOfAuthority(address creator, bytes signature, string agreementFileCID, string proofCID, string proofJSON)
```

### ProofOfSignature

```solidity
event ProofOfSignature(address signer, bytes signature, string agreementFileCID, string proofCID, string proofJSON)
```

### ProofOfAgreement

```solidity
event ProofOfAgreement(string agreementFileCID, string proofOfAuthorityCID, string proofCID, string proofJSON)
```

### constructor

```solidity
constructor(address _proofsMetadata) public
```

### fetchProofOfAuthorityData

```solidity
function fetchProofOfAuthorityData(address _creator, address[] _signers, string _agreementFileCID, string _version) public returns (string)
```

### fetchProofOfSignatureData

```solidity
function fetchProofOfSignatureData(address _signer, string _agreementFileCID, string _proofOfAuthorityCID, string _version) public returns (string)
```

Note: there is no check that the _proofOfAuthorityCID is actually for this proof. This check
      should be done offchain.

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
function storeProofOfAgreement(string _agreementFileCID, string _proofOfAuthorityCID, string _proofOfAgreementCID) public
```

