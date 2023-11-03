// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { ECDSA } from '@openzeppelin/contracts/utils/cryptography/ECDSA.sol';

abstract contract Proofs {
    bytes32 constant EIP712DOMAIN_TYPEHASH = keccak256('EIP712Domain(string name,string version)');
    bytes32 constant SIGNER_TYPEHASH = keccak256('Signer(address addr,string metadata)');
    bytes32 constant PROOF_AUTHORITY_TYPEHASH =
        keccak256(
            'ProofOfAuthority(string name,address from,string filecid,Signer[] signers,string app,uint256 timestamp,string metadata)Signer(address addr,string metadata)'
        );
    bytes32 constant PROOF_SIGNATURE_TYPEHASH =
        keccak256(
            'ProofOfSignature(string name,address signer,string filecid,string app,uint256 timestamp,string metadata)'
        );
    bytes32 constant FILECID_TYPEHASH = keccak256('Filecid(string addr,string data)');
    bytes32 constant PROOF_AGREEMENT_TYPEHASH =
        keccak256(
            'ProofOfAgreement(string filecid,Filecid[] signcids,string app,uint256 timestamp,string metadata)Filecid(string addr,string data)'
        );
    bytes32 DOMAIN_HASH;

    enum ProofKind {
        Authority,
        Signature,
        Agreement
    }

    struct EIP712Domain {
        string name;
        string version;
    }

    struct Signer {
        address addr;
        string metadata;
    }

    struct ProofOfAuthority {
        string name;
        address from;
        string filecid;
        Signer[] signers;
        string app;
        uint256 timestamp;
        string metadata;
    }

    struct ProofOfSignature {
        string name;
        address signer;
        string filecid;
        string app;
        uint256 timestamp;
        string metadata;
    }

    struct Filecid {
        string addr;
        string data;
    }

    struct ProofOfAgreement {
        string filecid;
        Filecid[] signcids;
        string app;
        uint256 timestamp;
        string metadata;
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

    function hash(ProofOfAuthority memory _input) internal pure returns (bytes32) {
        bytes memory encoded = abi.encode(
            PROOF_AUTHORITY_TYPEHASH,
            keccak256(bytes(_input.name)),
            _input.from,
            keccak256(bytes(_input.filecid)),
            hash(_input.signers),
            keccak256(bytes(_input.app)),
            _input.timestamp,
            keccak256(bytes(_input.metadata))
        );
        return keccak256(encoded);
    }

    function hash(ProofOfSignature memory _input) internal pure returns (bytes32) {
        bytes memory encoded = abi.encode(
            PROOF_SIGNATURE_TYPEHASH,
            keccak256(bytes(_input.name)),
            _input.signer,
            keccak256(bytes(_input.filecid)),
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

    function hash(ProofOfAgreement memory _input) internal pure returns (bytes32) {
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
        ProofOfAuthority memory message,
        bytes memory signature
    ) public view returns (address) {
        bytes32 packetHash = hash(message);
        bytes32 digest = keccak256(abi.encodePacked('\x19\x01', DOMAIN_HASH, packetHash));
        return ECDSA.recover(digest, signature);
    }

    function recover(
        ProofOfSignature memory message,
        bytes memory signature
    ) public view returns (address) {
        bytes32 packetHash = hash(message);
        bytes32 digest = keccak256(abi.encodePacked('\x19\x01', DOMAIN_HASH, packetHash));
        return ECDSA.recover(digest, signature);
    }

    function recover(
        ProofOfAgreement memory message,
        bytes memory signature
    ) public view returns (address) {
        bytes32 packetHash = hash(message);
        bytes32 digest = keccak256(abi.encodePacked('\x19\x01', DOMAIN_HASH, packetHash));
        return ECDSA.recover(digest, signature);
    }

    function store(ProofOfAuthority memory message, bytes memory signature) public {
        require(recover(message, signature) == message.from);
        require(validate(message));
        save(message);
    }

    function store(ProofOfSignature memory message, bytes memory signature) public {
        require(recover(message, signature) == message.signer);
        require(validate(message));
        save(message);
    }

    function store(ProofOfAgreement memory message, bytes memory signature) public {
        require(recover(message, signature) == msg.sender);
        require(validate(message));
        save(message);
    }

    function validate(ProofOfAuthority memory) internal view virtual returns (bool);

    function validate(ProofOfSignature memory) internal view virtual returns (bool);

    function validate(ProofOfAgreement memory) internal view virtual returns (bool);

    function save(ProofOfAuthority memory) internal virtual;

    function save(ProofOfSignature memory) internal virtual;

    function save(ProofOfAgreement memory) internal virtual;
}
