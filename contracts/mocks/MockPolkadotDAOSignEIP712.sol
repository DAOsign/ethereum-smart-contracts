// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import 'hardhat/console.sol';

import { DAOSignEIP712, EIP712Domain, ProofOfAuthority, ProofOfSignature, ProofOfAgreement, PROOF_OF_AUTHORITY_TYPEHASH, PROOF_OF_SIGNATURE_TYPEHASH, PROOF_OF_AGREEMENT_TYPEHASH } from '../DAOSignEIP712.sol';

contract MockPolkadotDAOSignEIP712 is DAOSignEIP712 {
    constructor(EIP712Domain memory _domain) {
        domain = _domain;
        DOMAIN_HASH = hash(_domain);
        initEIP712Types();
    }

    function hash(ProofOfAuthority memory data) internal pure override returns (bytes32) {
        bytes memory encoded = abi.encode(
            PROOF_OF_AUTHORITY_TYPEHASH,
            keccak256(bytes(data.name)),
            data.from,
            keccak256(bytes(data.agreementCID)),
            hash(data.signers),
            keccak256(bytes(data.app)),
            data.timestamp,
            keccak256(bytes(data.metadata))
        );
        console.log("\nProof-of-Authority's abi encoded proof:");
        console.logBytes(encoded);
        return keccak256(encoded);
    }

    function hash(ProofOfSignature memory data) internal pure override returns (bytes32) {
        bytes memory encoded = abi.encode(
            PROOF_OF_SIGNATURE_TYPEHASH,
            keccak256(bytes(data.name)),
            data.signer,
            keccak256(bytes(data.agreementCID)),
            keccak256(bytes(data.app)),
            data.timestamp,
            keccak256(bytes(data.metadata))
        );
        console.log("\nProof-of-Signature's abi encoded proof:");
        console.logBytes(encoded);
        return keccak256(encoded);
    }

    function hash(ProofOfAgreement memory data) internal pure override returns (bytes32) {
        bytes memory encoded = abi.encode(
            PROOF_OF_AGREEMENT_TYPEHASH,
            keccak256(bytes(data.agreementCID)),
            hash(data.signatureCIDs),
            keccak256(bytes(data.app)),
            data.timestamp,
            keccak256(bytes(data.metadata))
        );
        console.log("\nProof-of-Agreement's abi encoded proof:");
        console.logBytes(encoded);
        return keccak256(encoded);
    }

    function recover(
        ProofOfAuthority memory data,
        bytes memory signature
    ) internal view override returns (address) {
        bytes32 packedHash = hash(data);
        console.log("\nProof-of-Authority's packed hash:");
        console.logBytes32(packedHash);
        bytes32 digest = keccak256(abi.encodePacked('\x19\x01', DOMAIN_HASH, packedHash));
        return recover(digest, signature);
    }

    function recover(
        ProofOfSignature memory data,
        bytes memory signature
    ) internal view override returns (address) {
        bytes32 packedHash = hash(data);
        console.log("\nProof-of-Signature's packed hash:");
        console.logBytes32(packedHash);
        bytes32 digest = keccak256(abi.encodePacked('\x19\x01', DOMAIN_HASH, packedHash));
        return recover(digest, signature);
    }

    function recover(
        ProofOfAgreement memory data,
        bytes memory signature
    ) internal view override returns (address) {
        bytes32 packedHash = hash(data);
        console.log("\nProof-of-Agreement's packed hash:");
        console.logBytes32(packedHash);
        bytes32 digest = keccak256(abi.encodePacked('\x19\x01', DOMAIN_HASH, packedHash));
        return recover(digest, signature);
    }

    function recoverProofOfAuthority(
        ProofOfAuthority memory message,
        bytes memory signature
    ) public view returns (address) {
        return recover(message, signature);
    }

    function recoverProofOfSignature(
        ProofOfSignature memory message,
        bytes memory signature
    ) public view returns (address) {
        return recover(message, signature);
    }

    function recoverProofOfAgreement(
        ProofOfAgreement memory message,
        bytes memory signature
    ) public view returns (address) {
        return recover(message, signature);
    }
}
