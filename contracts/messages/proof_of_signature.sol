// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { EIP712PropertyType, EIP712Domain, recover as eiprecover } from './domain.sol';

bytes32 constant PROOF_OF_SIGNATURE_TYPEHASH = keccak256(
    'ProofOfSignature(string name,address signer,string authorityCID,uint256 timestamp,string metadata)'
);

struct ProofOfSignature {
    string name;
    address signer;
    string authorityCID;
    uint256 timestamp;
    string metadata;
}

struct EIP712ProofOfSignatureTypes {
    EIP712PropertyType[2] EIP712Domain;
    EIP712PropertyType[5] ProofOfSignature;
}

struct EIP712ProofOfSignatureDocument {
    EIP712ProofOfSignatureTypes types;
    EIP712Domain domain;
    string primaryType;
    ProofOfSignature message;
}

interface IEIP712ProofOfSignature {
    function hash(ProofOfSignature memory data) external pure returns (bytes32);

    function recover(
        bytes32 domainHash,
        ProofOfSignature memory data,
        bytes memory signature
    ) external pure returns (address);

    function toEIP712Message(
        EIP712Domain memory domain,
        ProofOfSignature memory message
    ) external view returns (EIP712ProofOfSignatureDocument memory);
}

contract EIP712ProofOfSignature is IEIP712ProofOfSignature {
    EIP712ProofOfSignatureDocument internal proofOfSignatureDoc;

    constructor() {
        proofOfSignatureDoc.types.EIP712Domain[0] = EIP712PropertyType({
            name: 'name',
            kind: 'string'
        });
        proofOfSignatureDoc.types.EIP712Domain[1] = EIP712PropertyType({
            name: 'version',
            kind: 'string'
        });
        proofOfSignatureDoc.types.ProofOfSignature[0] = EIP712PropertyType({
            name: 'name',
            kind: 'string'
        });
        proofOfSignatureDoc.types.ProofOfSignature[1] = EIP712PropertyType({
            name: 'signer',
            kind: 'address'
        });
        proofOfSignatureDoc.types.ProofOfSignature[2] = EIP712PropertyType({
            name: 'authorityCID',
            kind: 'string'
        });
        proofOfSignatureDoc.types.ProofOfSignature[3] = EIP712PropertyType({
            name: 'timestamp',
            kind: 'uint256'
        });
        proofOfSignatureDoc.types.ProofOfSignature[4] = EIP712PropertyType({
            name: 'metadata',
            kind: 'string'
        });
        proofOfSignatureDoc.primaryType = 'ProofOfSignature';
    }

    function hash(ProofOfSignature memory data) public pure returns (bytes32) {
        bytes memory encoded = abi.encode(
            PROOF_OF_SIGNATURE_TYPEHASH,
            keccak256(bytes(data.name)),
            data.signer,
            keccak256(bytes(data.authorityCID)),
            data.timestamp,
            keccak256(bytes(data.metadata))
        );
        return keccak256(encoded);
    }

    function recover(
        bytes32 domainHash,
        ProofOfSignature memory data,
        bytes memory signature
    ) public pure returns (address) {
        bytes32 packetHash = hash(data);
        bytes32 digest = keccak256(abi.encodePacked('\x19\x01', domainHash, packetHash));
        return eiprecover(digest, signature);
    }

    function toEIP712Message(
        EIP712Domain memory domain,
        ProofOfSignature memory message
    ) public view returns (EIP712ProofOfSignatureDocument memory) {
        EIP712ProofOfSignatureDocument memory doc = proofOfSignatureDoc;
        doc.domain = domain;
        doc.message = message;
        return doc;
    }
}
