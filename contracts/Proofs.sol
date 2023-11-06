// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { ECDSA } from '@openzeppelin/contracts/utils/cryptography/ECDSA.sol';
import { StringUtils } from './lib/StringUtils.sol';
import { Initializable } from '@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol';
import { Ownable } from '@openzeppelin/contracts/access/Ownable.sol';

abstract contract Proofs is Initializable, Ownable {
    using StringUtils for string;

    bytes32 public EIP712DOMAIN_TYPEHASH = keccak256('EIP712Domain(string name,string version)');
    bytes32 public SIGNER_TYPEHASH = keccak256('Signer(address addr,string metadata)');
    bytes32 public PROOF_AUTHORITY_TYPEHASH =
        keccak256(
            'ProofOfAuthority(string name,address from,string agreementFileCID,Signer[] signers,string app,uint64 timestamp,string metadata)Signer(address addr,string metadata)'
        );
    bytes32 public PROOF_SIGNATURE_TYPEHASH =
        keccak256(
            'ProofOfSignature(string name,address signer,string agreementFileProofCID,string app,uint64 timestamp,string metadata)'
        );
    bytes32 public AGR_SIGN_PROOF_TYPEHASH = keccak256('AgreementSignProof(string proofCID)');
    bytes32 public PROOF_AGREEMENT_TYPEHASH =
        keccak256(
            'ProofOfAgreement(string agreementFileProofCID,AgreementSignProof[] agreementSignProofs,uint64 timestamp,string metadata)AgreementSignProof(string proofCID)'
        );
    bytes32 public DOMAIN_HASH;

    struct EIP712Domain {
        string name;
        string version;
    }

    struct Signer {
        address addr;
        string metadata;
    }

    struct ProofOfAuthorityMsg {
        string name;
        address from;
        string agreementFileCID;
        Signer[] signers;
        string app;
        uint64 timestamp;
        string metadata;
    }

    struct ProofOfAuthorityShrinked {
        bytes sig;
        string version;
        ProofOfAuthorityMsg message;
    }

    struct ProofOfSignatureMsg {
        string name;
        address signer;
        string agreementFileProofCID;
        string app;
        uint64 timestamp;
        string metadata;
    }

    struct ProofOfSignatureShrinked {
        bytes sig;
        string version;
        ProofOfSignatureMsg message;
    }

    struct AgreementSignProof {
        string proofCID;
    }

    struct ProofOfAgreement {
        string agreementFileProofCID;
        AgreementSignProof[] agreementSignProofs;
        uint64 timestamp;
        string metadata;
    }

    event NewProofOfAuthority(ProofOfAuthorityShrinked indexed proof);
    event NewProofOfSignature(ProofOfSignatureShrinked indexed proof);
    event NewProofOfAgreement(ProofOfAgreement indexed proof);

    event DomainHashUpdated(EIP712Domain indexed domain);
    event EIP712DomainTypeHashUpdated(string indexed eip712DomainTypeHash);
    event SignerTypeHashUpdated(string indexed signerTypeHash);
    event ProofAuthorityTypeHashUpdated(string indexed proofAuthorityTypeHash);
    event ProofSignatureTypeHashUpdated(string indexed proofSignatureTypeHash);
    event AgrSignProofTypeHashUpdated(string indexed agrSignProofTypeHash);
    event ProofAgreementTypeHashUpdated(string indexed proofAgreementTypeHash);

    function initialize(address _owner) public initializer {
        DOMAIN_HASH = hash(EIP712Domain({ name: 'daosign', version: '0.1.0' }));
        _transferOwnership(_owner);
    }

    function updateDomainHash(EIP712Domain memory _domain) external onlyOwner {
        DOMAIN_HASH = hash(_domain);
        emit DomainHashUpdated(_domain);
    }

    function updateEIP712DomainTypeHash(string memory _eip712Domain) external onlyOwner {
        EIP712DOMAIN_TYPEHASH = keccak256(abi.encodePacked(_eip712Domain));
        emit EIP712DomainTypeHashUpdated(_eip712Domain);
    }

    function updateSignerTypeHash(string memory _signerType) external onlyOwner {
        SIGNER_TYPEHASH = keccak256(abi.encodePacked(_signerType));
        emit SignerTypeHashUpdated(_signerType);
    }

    function updateProofAuthorityTypeHash(string memory _proofAuthorityType) external onlyOwner {
        PROOF_AUTHORITY_TYPEHASH = keccak256(abi.encodePacked(_proofAuthorityType));
        emit ProofAuthorityTypeHashUpdated(_proofAuthorityType);
    }

    function updateProofSignatureTypeHash(string memory _proofSignatureType) external onlyOwner {
        PROOF_SIGNATURE_TYPEHASH = keccak256(abi.encodePacked(_proofSignatureType));
        emit ProofSignatureTypeHashUpdated(_proofSignatureType);
    }

    function updateAgrSignProofTypeHash(string memory _agrSignProofType) external onlyOwner {
        AGR_SIGN_PROOF_TYPEHASH = keccak256(abi.encodePacked(_agrSignProofType));
        emit AgrSignProofTypeHashUpdated(_agrSignProofType);
    }

    function updateProofAgreementTypeHash(string memory _proofAgreementType) external onlyOwner {
        PROOF_AGREEMENT_TYPEHASH = keccak256(abi.encodePacked(_proofAgreementType));
        emit ProofAgreementTypeHashUpdated(_proofAgreementType);
    }

    function storeProofOfAuthority(
        ProofOfAuthorityShrinked memory _proof,
        string memory _proofCID
    ) external {
        require(_proofCID.length() == 46, 'Invalid proof CID');
        require(recover(_proof.message, _proof.sig) == _proof.message.from, 'Invalid signature');
        require(_validate(_proof), 'Invalid input params');
        _store(_proof, _proofCID);
    }

    function storeProofOfSignature(
        ProofOfSignatureShrinked memory _proof,
        string memory _proofCID
    ) external {
        require(_proofCID.length() == 46, 'Invalid proof CID');
        require(recover(_proof.message, _proof.sig) == _proof.message.signer, 'Invalid signature');
        require(_validate(_proof), 'Invalid input params');
        _store(_proof, _proofCID);
    }

    // TODO: call this function automatically once the last Proof-of-Signature is generated
    function storeProofOfAgreement(
        ProofOfAgreement memory _proof,
        string memory _proofCID
    ) external {
        require(_proofCID.length() == 46, 'Invalid proof CID');
        require(_validate(_proof), 'Invalid input params');
        _store(_proof, _proofCID);
    }

    function recover(
        ProofOfAuthorityMsg memory message,
        bytes memory signature
    ) public view returns (address) {
        bytes32 packetHash = hash(message);
        bytes32 digest = keccak256(abi.encodePacked('\x19\x01', DOMAIN_HASH, packetHash));
        return ECDSA.recover(digest, signature);
    }

    function recover(
        ProofOfSignatureMsg memory message,
        bytes memory signature
    ) public view returns (address) {
        bytes32 packetHash = hash(message);
        bytes32 digest = keccak256(abi.encodePacked('\x19\x01', DOMAIN_HASH, packetHash));
        return ECDSA.recover(digest, signature);
    }

    function hash(EIP712Domain memory _input) internal view returns (bytes32) {
        bytes memory encoded = abi.encode(
            EIP712DOMAIN_TYPEHASH,
            keccak256(bytes(_input.name)),
            keccak256(bytes(_input.version))
        );
        return keccak256(encoded);
    }

    function hash(Signer memory _input) internal view returns (bytes32) {
        bytes memory encoded = abi.encode(
            SIGNER_TYPEHASH,
            _input.addr,
            keccak256(bytes(_input.metadata))
        );
        return keccak256(encoded);
    }

    function hash(Signer[] memory _input) internal view returns (bytes32) {
        bytes memory encoded;
        for (uint i = 0; i < _input.length; i++) {
            encoded = abi.encodePacked(encoded, hash(_input[i]));
        }
        return keccak256(encoded);
    }

    function hash(ProofOfAuthorityMsg memory _input) internal view returns (bytes32) {
        bytes memory encoded = abi.encode(
            PROOF_AUTHORITY_TYPEHASH,
            keccak256(bytes(_input.name)),
            _input.from,
            keccak256(bytes(_input.agreementFileCID)),
            hash(_input.signers),
            keccak256(bytes(_input.app)),
            _input.timestamp,
            keccak256(bytes(_input.metadata))
        );
        return keccak256(encoded);
    }

    function hash(ProofOfSignatureMsg memory _input) internal view returns (bytes32) {
        bytes memory encoded = abi.encode(
            PROOF_SIGNATURE_TYPEHASH,
            keccak256(bytes(_input.name)),
            _input.signer,
            keccak256(bytes(_input.agreementFileProofCID)),
            keccak256(bytes(_input.app)),
            _input.timestamp,
            keccak256(bytes(_input.metadata))
        );
        return keccak256(encoded);
    }

    function hash(AgreementSignProof memory _input) internal view returns (bytes32) {
        bytes memory encoded = abi.encode(
            AGR_SIGN_PROOF_TYPEHASH,
            keccak256(bytes(_input.proofCID))
        );
        return keccak256(encoded);
    }

    function hash(AgreementSignProof[] memory _input) internal view returns (bytes32) {
        bytes memory encoded;
        for (uint i = 0; i < _input.length; i++) {
            encoded = abi.encodePacked(encoded, hash(_input[i]));
        }
        return keccak256(encoded);
    }

    function hash(ProofOfAgreement memory _input) internal view returns (bytes32) {
        bytes memory encoded = abi.encode(
            PROOF_AGREEMENT_TYPEHASH,
            keccak256(bytes(_input.agreementFileProofCID)),
            hash(_input.agreementSignProofs),
            _input.timestamp
        );
        return keccak256(encoded);
    }

    function _validate(ProofOfAuthorityShrinked memory) internal view virtual returns (bool);

    function _validate(ProofOfSignatureShrinked memory) internal view virtual returns (bool);

    function _validate(ProofOfAgreement memory) internal view virtual returns (bool);

    function _store(ProofOfAuthorityShrinked memory, string memory) internal virtual;

    function _store(ProofOfSignatureShrinked memory, string memory) internal virtual;

    function _store(ProofOfAgreement memory, string memory) internal virtual;

    function getProofOfAuthority(
        string memory
    ) public virtual returns (ProofOfAuthorityShrinked memory);

    function getProofOfSignature(
        string memory
    ) public virtual returns (ProofOfSignatureShrinked memory);

    function getProofOfAgreement(string memory) public virtual returns (ProofOfAgreement memory);
}
