// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { ECDSA } from '@openzeppelin/contracts/utils/cryptography/ECDSA.sol';
import { Initializable } from '@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol';
import { Ownable } from '@openzeppelin/contracts/access/Ownable.sol';
import { StringUtils } from './lib/StringUtils.sol';
import { Proofs } from './Proofs.sol';

contract ProofsBase is Proofs, Initializable, Ownable {
    using StringUtils for string;

    mapping(string => bytes) public proofs;

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

    function initializeProofsBase(address _owner) public onlyInitializing {
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

    function recover(
        ProofOfAuthorityMsg memory message,
        bytes memory signature
    ) public view override returns (address) {
        bytes32 packetHash = hash(message);
        bytes32 digest = keccak256(abi.encodePacked('\x19\x01', DOMAIN_HASH, packetHash));
        return ECDSA.recover(digest, signature);
    }

    function recover(
        ProofOfSignatureMsg memory message,
        bytes memory signature
    ) public view override returns (address) {
        bytes32 packetHash = hash(message);
        bytes32 digest = keccak256(abi.encodePacked('\x19\x01', DOMAIN_HASH, packetHash));
        return ECDSA.recover(digest, signature);
    }

    function hash(EIP712Domain memory _input) internal view override returns (bytes32) {
        bytes memory encoded = abi.encode(
            EIP712DOMAIN_TYPEHASH,
            keccak256(bytes(_input.name)),
            keccak256(bytes(_input.version))
        );
        return keccak256(encoded);
    }

    function hash(Signer memory _input) internal view override returns (bytes32) {
        bytes memory encoded = abi.encode(
            SIGNER_TYPEHASH,
            _input.addr,
            keccak256(bytes(_input.metadata))
        );
        return keccak256(encoded);
    }

    function hash(Signer[] memory _input) internal view override returns (bytes32) {
        bytes memory encoded;
        for (uint i = 0; i < _input.length; i++) {
            encoded = abi.encodePacked(encoded, hash(_input[i]));
        }
        return keccak256(encoded);
    }

    function hash(ProofOfAuthorityMsg memory _input) internal view override returns (bytes32) {
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

    function hash(ProofOfSignatureMsg memory _input) internal view override returns (bytes32) {
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

    function hash(AgreementSignProof memory _input) internal view override returns (bytes32) {
        bytes memory encoded = abi.encode(
            AGR_SIGN_PROOF_TYPEHASH,
            keccak256(bytes(_input.proofCID))
        );
        return keccak256(encoded);
    }

    function hash(AgreementSignProof[] memory _input) internal view override returns (bytes32) {
        bytes memory encoded;
        for (uint i = 0; i < _input.length; i++) {
            encoded = abi.encodePacked(encoded, hash(_input[i]));
        }
        return keccak256(encoded);
    }

    function hash(ProofOfAgreement memory _input) internal view override returns (bytes32) {
        bytes memory encoded = abi.encode(
            PROOF_AGREEMENT_TYPEHASH,
            keccak256(bytes(_input.agreementFileProofCID)),
            hash(_input.agreementSignProofs),
            _input.timestamp
        );
        return keccak256(encoded);
    }

    function _validate(
        ProofOfAuthorityShrinked memory _proof
    ) internal view override returns (bool) {
        require(_proof.version.length() > 0, 'Invalid version');
        require(_proof.message.name.equal('Proof-of-Authority'), 'Invalid name');
        require(_proof.message.agreementFileCID.length() == 46, 'Invalid CID length');
        require(_proof.message.app.equal('daosign'), 'Invalid app');
        require(
            _proof.message.timestamp <= block.timestamp &&
                _proof.message.timestamp >= block.timestamp - 3 hours,
            'Invalid timestamp'
        );

        for (uint256 i = 0; i < _proof.message.signers.length; i++) {
            require(_proof.message.signers[i].addr != address(0), 'Invalid signer');
        }

        return true;
    }

    function _validate(
        ProofOfSignatureShrinked memory _proof
    ) internal view override returns (bool) {
        require(_proof.version.length() > 0, 'Invalid version');
        require(_proof.message.name.equal('Proof-of-Signature'), 'Invalid name');
        require(_proof.message.agreementFileProofCID.length() == 46, 'Invalid CID length');
        require(_proof.message.app.equal('daosign'), 'Invalid app');
        require(
            _proof.message.timestamp <= block.timestamp &&
                _proof.message.timestamp >= block.timestamp - 3 hours,
            'Invalid timestamp'
        );

        return true;
    }

    function _validate(ProofOfAgreement memory _proof) internal view override returns (bool) {
        require(_proof.agreementFileProofCID.length() == 46, 'Invalid Proof-of-Authority CID');
        for (uint256 i = 0; i < _proof.agreementSignProofs.length; i++) {
            require(
                _proof.agreementSignProofs[i].proofCID.length() == 46,
                'Invalid Proof-of-Signature CID'
            );
        }
        require(
            _proof.timestamp <= block.timestamp && _proof.timestamp >= block.timestamp - 3 hours,
            'Invalid timestamp'
        );
        return true;
    }

    function _store(
        ProofOfAuthorityShrinked memory _proof,
        string memory _proofCID
    ) internal override {
        proofs[_proofCID] = abi.encode(
            ProofOfAuthorityShrinked(_proof.sig, _proof.version, _proof.message)
        );
        emit NewProofOfAuthority(_proof);
    }

    function _store(
        ProofOfSignatureShrinked memory _proof,
        string memory _proofCID
    ) internal override {
        proofs[_proofCID] = abi.encode(
            ProofOfSignatureShrinked(_proof.sig, _proof.version, _proof.message)
        );
        emit NewProofOfSignature(_proof);
    }

    function _store(ProofOfAgreement memory _proof, string memory _proofCID) internal override {
        proofs[_proofCID] = abi.encode(
            ProofOfAgreement(
                _proof.agreementFileProofCID,
                _proof.agreementSignProofs,
                _proof.timestamp,
                _proof.metadata
            )
        );
        emit NewProofOfAgreement(_proof);
    }
}
