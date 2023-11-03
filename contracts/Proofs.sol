// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { ECDSA } from '@openzeppelin/contracts/utils/cryptography/ECDSA.sol';

abstract contract Proofs {
    bytes32 constant EIP712DOMAIN_TYPEHASH = keccak256('EIP712Domain(string name,string version)');
    bytes32 constant SIGNER_TYPEHASH = keccak256('Signer(address addr,string metadata)');
    bytes32 constant PROOF_AUTHORITY_TYPEHASH =
        keccak256(
            'ProofOfAuthority(string name,address from,string agreementFileCID,Signer[] signers,string app,uint64 timestamp,string metadata)Signer(address addr,string metadata)'
        );
    bytes32 constant PROOF_SIGNATURE_TYPEHASH =
        keccak256(
            'ProofOfSignature(string name,address signer,string agreementFileProofCID,string app,uint64 timestamp,string metadata)'
        );
    bytes32 constant FILECID_TYPEHASH = keccak256('Filecid(string addr,string data)');
    bytes32 constant PROOF_AGREEMENT_TYPEHASH =
        keccak256(
            'ProofOfAgreement(string filecid,Filecid[] signcids,string app,uint64 timestamp,string metadata)Filecid(string addr,string data)'
        );
    bytes32 DOMAIN_HASH;

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

    struct Filecid {
        string addr;
        string data;
    }

    struct ProofOfAgreementMsg {
        string filecid;
        Filecid[] signcids;
        string app;
        uint64 timestamp;
        string metadata;
    }

    struct ProofOfAgreementShrinked {
        string version;
        ProofOfSignatureMsg message;
    }

    constructor() {
        DOMAIN_HASH = hash(EIP712Domain({ name: 'daosign', version: '0.1.0' }));
    }

    function hash(EIP712Domain memory _input) internal pure returns (bytes32) {
        bytes memory encoded = abi.encode(
            EIP712DOMAIN_TYPEHASH,
            keccak256(bytes(_input.name)),
            keccak256(bytes(_input.version))
        );
        return keccak256(encoded);
    }

    function hash(Signer memory _input) internal pure returns (bytes32) {
        bytes memory encoded = abi.encode(
            SIGNER_TYPEHASH,
            _input.addr,
            keccak256(bytes(_input.metadata))
        );
        return keccak256(encoded);
    }

    function hash(Signer[] memory _input) internal pure returns (bytes32) {
        bytes memory encoded;
        for (uint i = 0; i < _input.length; i++) {
            encoded = abi.encodePacked(encoded, hash(_input[i]));
        }
        return keccak256(encoded);
    }

    function hash(ProofOfAuthorityMsg memory _input) internal pure returns (bytes32) {
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

    function hash(ProofOfSignatureMsg memory _input) internal pure returns (bytes32) {
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

    function hash(Filecid memory _input) internal pure returns (bytes32) {
        bytes memory encoded = abi.encode(
            FILECID_TYPEHASH,
            keccak256(bytes(_input.addr)),
            keccak256(bytes(_input.data))
        );
        return keccak256(encoded);
    }

    function hash(Filecid[] memory _input) internal pure returns (bytes32) {
        bytes memory encoded;
        for (uint i = 0; i < _input.length; i++) {
            encoded = abi.encodePacked(encoded, hash(_input[i]));
        }
        return keccak256(encoded);
    }

    function hash(ProofOfAgreementMsg memory _input) internal pure returns (bytes32) {
        bytes memory encoded = abi.encode(
            PROOF_AGREEMENT_TYPEHASH,
            keccak256(bytes(_input.filecid)),
            hash(_input.signcids),
            keccak256(bytes(_input.app)),
            _input.timestamp,
            keccak256(bytes(_input.metadata))
        );
        return keccak256(encoded);
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

    function recover(
        ProofOfAgreementMsg memory message,
        bytes memory signature
    ) public view returns (address) {
        bytes32 packetHash = hash(message);
        bytes32 digest = keccak256(abi.encodePacked('\x19\x01', DOMAIN_HASH, packetHash));
        return ECDSA.recover(digest, signature);
    }

    function store(ProofOfAuthorityShrinked memory data) public {
        require(recover(data.message, data.sig) == data.message.from);
        require(validate(data));
        save(data);
    }

    function store(ProofOfSignatureShrinked memory data) public {
        require(recover(data.message, data.sig) == data.message.signer);
        require(validate(data));
        save(data);
    }

    function store(ProofOfAgreementShrinked memory data) public {
        require(validate(data));
        save(data);
    }

    function validate(ProofOfAuthorityShrinked memory) internal view virtual returns (bool);

    function validate(ProofOfSignatureShrinked memory) internal view virtual returns (bool);

    function validate(ProofOfAgreementShrinked memory) internal view virtual returns (bool);

    function save(ProofOfAuthorityShrinked memory) internal virtual;

    function save(ProofOfSignatureShrinked memory) internal virtual;

    function save(ProofOfAgreementShrinked memory) internal virtual;
}
