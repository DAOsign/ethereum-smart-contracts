## ProofsHelper

### getProofOfAuthorityOrSignature

```solidity
function getProofOfAuthorityOrSignature(address _creator, bytes _signature, string _data) external pure returns (string proof)
```

### getProofOfAuthorityData

```solidity
function getProofOfAuthorityData(address _proofsMetadata, address _creator, address[] _signers, string _agreementFileCID, string _version, uint256 _timestamp) external view returns (string)
```

### getProofOfSignatureData

```solidity
function getProofOfSignatureData(address _proofsMetadata, address _signer, string _proofOfAuthorityCID, string _version, uint256 _timestamp) external view returns (string)
```

### getProofOfAgreementData

```solidity
function getProofOfAgreementData(string _proofOfAuthorityCID, string[] _proofsOfSignatureCID, uint256 _timestamp) external pure returns (string)
```

### getProofOfAuthorityDataMessage

```solidity
function getProofOfAuthorityDataMessage(address _creator, address[] _signers, string _agreementFileCID, uint256 _timestamp) public pure returns (string message)
```

### getProofOfSignatureDataMessage

```solidity
function getProofOfSignatureDataMessage(address _signer, string _proofOfAuthorityCID, uint256 _timestamp) public pure returns (string message)
```

### generateSignersJSON

```solidity
function generateSignersJSON(address[] _signers) public pure returns (string)
```

