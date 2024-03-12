// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { EIP712PropertyType, EIP712Domain, recover as eiprecover } from './domain.sol';

bytes32 constant SIGNER_TYPEHASH = keccak256('Signer(address addr,string metadata)');

bytes32 constant PROOF_OF_AUTHORITY_TYPEHASH = keccak256(
    'ProofOfAuthority(string name,address from,string agreementCID,Signer[] signers,uint256 timestamp,string metadata)Signer(address addr,string metadata)'
);

struct Signer {
    address addr;
    string metadata;
}

struct ProofOfAuthority {
    string name;
    address from;
    string agreementCID;
    Signer[] signers;
    uint256 timestamp;
    string metadata;
}

struct EIP712ProofOfAuthorityTypes {
    EIP712PropertyType[2] EIP712Domain;
    EIP712PropertyType[2] Signer;
    EIP712PropertyType[6] ProofOfAuthority;
}

struct EIP712ProofOfAuthorityDocument {
    EIP712ProofOfAuthorityTypes types;
    EIP712Domain domain;
    string primaryType;
    ProofOfAuthority message;
}

interface IEIP721ProofOfAuthority {
    function hash(ProofOfAuthority memory data) external pure returns (bytes32);

    function recover(
        bytes32 domainHash,
        ProofOfAuthority memory data,
        bytes memory signature
    ) external pure returns (address);

    function toEIP712Message(
        EIP712Domain memory domain,
        ProofOfAuthority memory message
    ) external view returns (EIP712ProofOfAuthorityDocument memory);
}

contract EIP721ProofOfAuthority is IEIP721ProofOfAuthority {
    EIP712ProofOfAuthorityDocument internal proofOfAuthorityDoc;

    constructor() {
        proofOfAuthorityDoc.types.EIP712Domain[0] = EIP712PropertyType({
            name: 'name',
            kind: 'string'
        });
        proofOfAuthorityDoc.types.EIP712Domain[1] = EIP712PropertyType({
            name: 'version',
            kind: 'string'
        });
        proofOfAuthorityDoc.types.Signer[0] = EIP712PropertyType({ name: 'addr', kind: 'address' });
        proofOfAuthorityDoc.types.Signer[1] = EIP712PropertyType({
            name: 'metadata',
            kind: 'string'
        });
        proofOfAuthorityDoc.types.ProofOfAuthority[0] = EIP712PropertyType({
            name: 'name',
            kind: 'string'
        });
        proofOfAuthorityDoc.types.ProofOfAuthority[1] = EIP712PropertyType({
            name: 'from',
            kind: 'address'
        });
        proofOfAuthorityDoc.types.ProofOfAuthority[2] = EIP712PropertyType({
            name: 'agreementCID',
            kind: 'string'
        });
        proofOfAuthorityDoc.types.ProofOfAuthority[3] = EIP712PropertyType({
            name: 'signers',
            kind: 'Signer[]'
        });
        proofOfAuthorityDoc.types.ProofOfAuthority[4] = EIP712PropertyType({
            name: 'timestamp',
            kind: 'uint256'
        });
        proofOfAuthorityDoc.types.ProofOfAuthority[5] = EIP712PropertyType({
            name: 'metadata',
            kind: 'string'
        });
        proofOfAuthorityDoc.primaryType = 'ProofOfAuthority';
    }

    function hash(ProofOfAuthority memory data) public pure returns (bytes32) {
        bytes memory signers;
        for (uint i = 0; i < data.signers.length; i++) {
            signers = abi.encodePacked(
                signers,
                keccak256(
                    abi.encode(
                        SIGNER_TYPEHASH,
                        data.signers[i].addr,
                        keccak256(bytes(data.signers[i].metadata))
                    )
                )
            );
        }
        bytes memory encoded = abi.encode(
            PROOF_OF_AUTHORITY_TYPEHASH,
            keccak256(bytes(data.name)),
            data.from,
            keccak256(bytes(data.agreementCID)),
            keccak256(signers),
            data.timestamp,
            keccak256(bytes(data.metadata))
        );
        return keccak256(encoded);
    }

    function recover(
        bytes32 domainHash,
        ProofOfAuthority memory data,
        bytes memory signature
    ) public pure returns (address) {
        bytes32 packetHash = hash(data);
        bytes32 digest = keccak256(abi.encodePacked('\x19\x01', domainHash, packetHash));
        return eiprecover(digest, signature);
    }

    function toEIP712Message(
        EIP712Domain memory domain,
        ProofOfAuthority memory message
    ) public view returns (EIP712ProofOfAuthorityDocument memory) {
        EIP712ProofOfAuthorityDocument memory doc = proofOfAuthorityDoc;
        doc.domain = domain;
        doc.message = message;
        return doc;
    }
}
