// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { EIP712PropertyType, EIP712Domain, recover as eiprecover } from './domain.sol';

bytes32 constant PROOF_OF_CANCEL_TYPEHASH = keccak256(
    'ProofOfCancel(string[] authorityCIDs,uint256 timestamp,string metadata)'
);

struct ProofOfCancel {
    string[] authorityCIDs;
    uint256 timestamp;
    string metadata;
}

struct EIP712ProofOfCancelTypes {
    EIP712PropertyType[2] EIP712Domain;
    EIP712PropertyType[3] ProofOfVoid;
}

struct EIP712ProofOfCancelDocument {
    EIP712ProofOfCancelTypes types;
    EIP712Domain domain;
    string primaryType;
    ProofOfCancel message;
}

interface IEIP712ProofOfCancel {
    function hash(ProofOfCancel memory data) external pure returns (bytes32);

    function recover(
        bytes32 domainHash,
        ProofOfCancel memory data,
        bytes memory signature
    ) external pure returns (address);

    function toEIP712Message(
        EIP712Domain memory domain,
        ProofOfCancel memory message
    ) external view returns (EIP712ProofOfCancelDocument memory);
}

contract EIP712ProofOfCancel is IEIP712ProofOfCancel {
    EIP712ProofOfCancelDocument internal proofOfVoidDoc;

    constructor() {
        proofOfVoidDoc.types.EIP712Domain[0] = EIP712PropertyType({ name: 'name', kind: 'string' });
        proofOfVoidDoc.types.EIP712Domain[1] = EIP712PropertyType({
            name: 'version',
            kind: 'string'
        });
        proofOfVoidDoc.types.ProofOfVoid[0] = EIP712PropertyType({
            name: 'authorityCIDs',
            kind: 'string[]'
        });
        proofOfVoidDoc.types.ProofOfVoid[1] = EIP712PropertyType({
            name: 'timestamp',
            kind: 'uint256'
        });
        proofOfVoidDoc.types.ProofOfVoid[2] = EIP712PropertyType({
            name: 'metadata',
            kind: 'string'
        });
        proofOfVoidDoc.primaryType = 'ProofOfVoid';
    }

    function hash(ProofOfCancel memory data) public pure returns (bytes32) {
        bytes memory authorityCIDs;
        for (uint i = 0; i < data.authorityCIDs.length; i++) {
            authorityCIDs = abi.encodePacked(
                authorityCIDs,
                keccak256(bytes(data.authorityCIDs[i]))
            );
        }
        bytes memory encoded = abi.encode(
            PROOF_OF_CANCEL_TYPEHASH,
            keccak256(bytes(authorityCIDs)),
            data.timestamp,
            keccak256(bytes(data.metadata))
        );
        return keccak256(encoded);
    }

    function recover(
        bytes32 domainHash,
        ProofOfCancel memory data,
        bytes memory signature
    ) public pure returns (address) {
        bytes32 packetHash = hash(data);
        bytes32 digest = keccak256(abi.encodePacked('\x19\x01', domainHash, packetHash));
        return eiprecover(digest, signature);
    }

    function toEIP712Message(
        EIP712Domain memory domain,
        ProofOfCancel memory message
    ) public view returns (EIP712ProofOfCancelDocument memory) {
        EIP712ProofOfCancelDocument memory doc = proofOfVoidDoc;
        doc.domain = domain;
        doc.message = message;
        return doc;
    }
}
