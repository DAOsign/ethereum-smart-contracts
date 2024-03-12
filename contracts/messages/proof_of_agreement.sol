// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { EIP712PropertyType, EIP712Domain, recover as eiprecover } from './domain.sol';

bytes32 constant PROOF_OF_AGREEMENT_TYPEHASH = keccak256(
    'ProofOfAgreement(string authorityCID,string[] signatureCIDs,uint256 timestamp,string metadata)'
);

struct ProofOfAgreement {
    string authorityCID;
    string[] signatureCIDs;
    uint256 timestamp;
    string metadata;
}

struct EIP712ProofOfAgreementTypes {
    EIP712PropertyType[2] EIP712Domain;
    EIP712PropertyType[4] ProofOfAgreement;
}

struct EIP712ProofOfAgreementDocument {
    EIP712ProofOfAgreementTypes types;
    EIP712Domain domain;
    string primaryType;
    ProofOfAgreement message;
}

interface IEIP712ProofOfAgreement {
    function hash(ProofOfAgreement memory data) external pure returns (bytes32);

    function recover(
        bytes32 domainHash,
        ProofOfAgreement memory data,
        bytes memory signature
    ) external pure returns (address);

    function toEIP712Message(
        EIP712Domain memory domain,
        ProofOfAgreement memory message
    ) external view returns (EIP712ProofOfAgreementDocument memory);
}

contract EIP712ProofOfAgreement is IEIP712ProofOfAgreement {
    EIP712ProofOfAgreementDocument internal proofOfAgreementDoc;

    constructor() {
        proofOfAgreementDoc.types.EIP712Domain[0] = EIP712PropertyType({
            name: 'name',
            kind: 'string'
        });
        proofOfAgreementDoc.types.EIP712Domain[1] = EIP712PropertyType({
            name: 'version',
            kind: 'string'
        });
        proofOfAgreementDoc.types.ProofOfAgreement[0] = EIP712PropertyType({
            name: 'authorityCID',
            kind: 'string'
        });
        proofOfAgreementDoc.types.ProofOfAgreement[1] = EIP712PropertyType({
            name: 'signatureCIDs',
            kind: 'string[]'
        });
        proofOfAgreementDoc.types.ProofOfAgreement[2] = EIP712PropertyType({
            name: 'timestamp',
            kind: 'uint256'
        });
        proofOfAgreementDoc.types.ProofOfAgreement[3] = EIP712PropertyType({
            name: 'metadata',
            kind: 'string'
        });
        proofOfAgreementDoc.primaryType = 'ProofOfAgreement';
    }

    function hash(ProofOfAgreement memory data) public pure returns (bytes32) {
        bytes memory signatureCIDs;
        for (uint i = 0; i < data.signatureCIDs.length; i++) {
            signatureCIDs = abi.encodePacked(
                signatureCIDs,
                keccak256(bytes(data.signatureCIDs[i]))
            );
        }
        bytes memory encoded = abi.encode(
            PROOF_OF_AGREEMENT_TYPEHASH,
            keccak256(bytes(data.authorityCID)),
            keccak256(signatureCIDs),
            data.timestamp,
            keccak256(bytes(data.metadata))
        );
        return keccak256(encoded);
    }

    function recover(
        bytes32 domainHash,
        ProofOfAgreement memory data,
        bytes memory signature
    ) public pure returns (address) {
        bytes32 packetHash = hash(data);
        bytes32 digest = keccak256(abi.encodePacked('\x19\x01', domainHash, packetHash));
        return eiprecover(digest, signature);
    }

    function toEIP712Message(
        EIP712Domain memory domain,
        ProofOfAgreement memory message
    ) public view returns (EIP712ProofOfAgreementDocument memory) {
        EIP712ProofOfAgreementDocument memory doc = proofOfAgreementDoc;
        doc.domain = domain;
        doc.message = message;
        return doc;
    }
}
