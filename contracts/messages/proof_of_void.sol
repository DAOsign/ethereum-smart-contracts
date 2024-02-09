// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { EIP712PropertyType, EIP712Domain, recover as eiprecover } from './domain.sol';

bytes32 constant PROOF_OF_VOID_TYPEHASH = keccak256(
    'ProofOfVoid(string authorityCID,string app,uint256 timestamp,string metadata)'
);

struct ProofOfVoid {
    string authorityCID;
    string app;
    uint256 timestamp;
    string metadata;
}

struct EIP712ProofOfVoidTypes {
    EIP712PropertyType[2] EIP712Domain;
    EIP712PropertyType[4] ProofOfVoid;
}

struct EIP712ProofOfVoidDocument {
    EIP712ProofOfVoidTypes types;
    EIP712Domain domain;
    string primaryType;
    ProofOfVoid message;
}

interface IEIP712ProofOfVoid {
    function hash(ProofOfVoid memory data) external pure returns (bytes32);

    function recover(
        bytes32 domainHash,
        ProofOfVoid memory data,
        bytes memory signature
    ) external pure returns (address);

    function toEIP712Message(
        EIP712Domain memory domain,
        ProofOfVoid memory message
    ) external view returns (EIP712ProofOfVoidDocument memory);
}

contract EIP712ProofOfVoid is IEIP712ProofOfVoid {
    EIP712ProofOfVoidDocument internal proofOfVoidDoc;

    constructor() {
        proofOfVoidDoc.types.EIP712Domain[0] = EIP712PropertyType({ name: 'name', kind: 'string' });
        proofOfVoidDoc.types.EIP712Domain[1] = EIP712PropertyType({
            name: 'version',
            kind: 'string'
        });
        proofOfVoidDoc.types.ProofOfVoid[0] = EIP712PropertyType({
            name: 'authorityCID',
            kind: 'string'
        });
        proofOfVoidDoc.types.ProofOfVoid[1] = EIP712PropertyType({ name: 'app', kind: 'string' });
        proofOfVoidDoc.types.ProofOfVoid[2] = EIP712PropertyType({
            name: 'timestamp',
            kind: 'uint256'
        });
        proofOfVoidDoc.types.ProofOfVoid[3] = EIP712PropertyType({
            name: 'metadata',
            kind: 'string'
        });
        proofOfVoidDoc.primaryType = 'ProofOfVoid';
    }

    function hash(ProofOfVoid memory data) public pure returns (bytes32) {
        bytes memory encoded = abi.encode(
            PROOF_OF_VOID_TYPEHASH,
            keccak256(bytes(data.authorityCID)),
            keccak256(bytes(data.app)),
            data.timestamp,
            keccak256(bytes(data.metadata))
        );
        return keccak256(encoded);
    }

    function recover(
        bytes32 domainHash,
        ProofOfVoid memory data,
        bytes memory signature
    ) public pure returns (address) {
        bytes32 packetHash = hash(data);
        bytes32 digest = keccak256(abi.encodePacked('\x19\x01', domainHash, packetHash));
        return eiprecover(digest, signature);
    }

    function toEIP712Message(
        EIP712Domain memory domain,
        ProofOfVoid memory message
    ) public view returns (EIP712ProofOfVoidDocument memory) {
        EIP712ProofOfVoidDocument memory doc = proofOfVoidDoc;
        doc.domain = domain;
        doc.message = message;
        return doc;
    }
}
