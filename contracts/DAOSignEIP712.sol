// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

/* * * * * * *
 * DAOSign EIP712 types
 * {
 *     domain: {
 *         name: "daosign",
 *         version: "0.1.0",
 *     },
 *     types: {
 *         EIP712Domain: [
 *             { name: "name", type: "string" },
 *             { name: "version", type: "string" },
 *             { name: "chainId", type: "uint256" },
 *             { name: "verifyingContract", type: "address" },
 *         ],
 *         Signer: [
 *             { name: "addr", type: "address" },
 *             { name: "metadata", type: "string" },
 *         ],
 *         ProofOfAuthority: [
 *             { name: "name", type: "string" },
 *             { name: "from", type: "address" },
 *             { name: "agreementCID", type: "string" },
 *             { name: "signers", type: "Signer[]" },
 *             { name: "app", type: "string" },
 *             { name: "timestamp", type: "uint256" },
 *             { name: "metadata", type: "string" },
 *         ],
 *         ProofOfSignature: [
 *             { name: "name", type: "string" },
 *             { name: "signer", type: "address" },
 *             { name: "agreementCID", type: "string" },
 *             { name: "app", type: "string" },
 *             { name: "timestamp", type: "uint256" },
 *             { name: "metadata", type: "string" },
 *         ],
 *         ProofOfAgreement: [
 *             { name: "agreementCID", type: "string" },
 *             { name: "signatureCIDs", type: "string[]" },
 *             { name: "app", type: "string" },
 *             { name: "timestamp", type: "uint256" },
 *             { name: "metadata", type: "string" },
 *         ],
 *     },
 * }
 * */

abstract contract DAOSignEIP712 {
    bytes32 internal constant EIP712DOMAIN_TYPEHASH =
        keccak256(
            'EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'
        );
    bytes32 internal constant SIGNER_TYPEHASH = keccak256('Signer(address addr,string metadata)');
    bytes32 internal constant PROOF_OF_AUTHORITY_TYPEHASH =
        keccak256(
            'ProofOfAuthority(string name,address from,string agreementCID,Signer[] signers,string app,uint256 timestamp,string metadata)Signer(address addr,string metadata)'
        );
    bytes32 internal constant PROOF_OF_SIGNATURE_TYPEHASH =
        keccak256(
            'ProofOfSignature(string name,address signer,string agreementCID,string app,uint256 timestamp,string metadata)'
        );
    bytes32 internal constant PROOF_OF_AGREEMENT_TYPEHASH =
        keccak256(
            'ProofOfAgreement(string agreementCID,string[] signatureCIDs,string app,uint256 timestamp,string metadata)'
        );

    bytes32 internal DOMAIN_HASH;
    EIP712Domain internal domain;
    EIP712ProofOfAuthority internal proofOfAuthorityDoc;
    EIP712ProofOfSignature internal proofOfSignatureDoc;
    EIP712ProofOfAgreement internal proofOfAgreementDoc;

    struct EIP712Domain {
        string name;
        string version;
        uint256 chainId;
        address verifyingContract;
    }

    struct Signer {
        address addr;
        string metadata;
    }

    struct ProofOfAuthority {
        string name;
        address from;
        string agreementCID;
        Signer[] signers;
        string app;
        uint256 timestamp;
        string metadata;
    }

    struct ProofOfSignature {
        string name;
        address signer;
        string agreementCID;
        string app;
        uint256 timestamp;
        string metadata;
    }

    struct ProofOfAgreement {
        string agreementCID;
        string[] signatureCIDs;
        string app;
        uint256 timestamp;
        string metadata;
    }

    struct EIP712PropertyType {
        string name;
        string kind;
    }

    struct EIP712ProofOfAuthorityTypes {
        EIP712PropertyType[4] EIP712Domain;
        EIP712PropertyType[2] Signer;
        EIP712PropertyType[7] ProofOfAuthority;
    }

    struct EIP712ProofOfAuthority {
        EIP712ProofOfAuthorityTypes types;
        EIP712Domain domain;
        string primaryType;
        ProofOfAuthority message;
    }

    struct EIP712ProofOfSignatureTypes {
        EIP712PropertyType[4] EIP712Domain;
        EIP712PropertyType[6] ProofOfSignature;
    }

    struct EIP712ProofOfSignature {
        EIP712ProofOfSignatureTypes types;
        EIP712Domain domain;
        string primaryType;
        ProofOfSignature message;
    }

    struct EIP712ProofOfAgreementTypes {
        EIP712PropertyType[4] EIP712Domain;
        EIP712PropertyType[5] ProofOfAgreement;
    }

    struct EIP712ProofOfAgreement {
        EIP712ProofOfAgreementTypes types;
        EIP712Domain domain;
        string primaryType;
        ProofOfAgreement message;
    }

    function initEIP712Types() internal {
        EIP712PropertyType memory domain0Doc = EIP712PropertyType({ name: 'name', kind: 'string' });
        EIP712PropertyType memory domain1Doc = EIP712PropertyType({
            name: 'version',
            kind: 'string'
        });
        EIP712PropertyType memory domain2Doc = EIP712PropertyType({
            name: 'chainId',
            kind: 'uint256'
        });
        EIP712PropertyType memory domain3Doc = EIP712PropertyType({
            name: 'verifyingContract',
            kind: 'address'
        });

        proofOfAuthorityDoc.types.EIP712Domain[0] = domain0Doc;
        proofOfAuthorityDoc.types.EIP712Domain[1] = domain1Doc;
        proofOfAuthorityDoc.types.EIP712Domain[2] = domain2Doc;
        proofOfAuthorityDoc.types.EIP712Domain[3] = domain3Doc;
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
            name: 'app',
            kind: 'string'
        });
        proofOfAuthorityDoc.types.ProofOfAuthority[5] = EIP712PropertyType({
            name: 'timestamp',
            kind: 'uint256'
        });
        proofOfAuthorityDoc.types.ProofOfAuthority[6] = EIP712PropertyType({
            name: 'metadata',
            kind: 'string'
        });
        proofOfAuthorityDoc.domain = domain;
        proofOfAuthorityDoc.primaryType = 'ProofOfAuthority';

        proofOfSignatureDoc.types.EIP712Domain[0] = domain0Doc;
        proofOfSignatureDoc.types.EIP712Domain[1] = domain1Doc;
        proofOfSignatureDoc.types.EIP712Domain[2] = domain2Doc;
        proofOfSignatureDoc.types.EIP712Domain[3] = domain3Doc;
        proofOfSignatureDoc.types.ProofOfSignature[0] = EIP712PropertyType({
            name: 'name',
            kind: 'string'
        });
        proofOfSignatureDoc.types.ProofOfSignature[1] = EIP712PropertyType({
            name: 'signer',
            kind: 'address'
        });
        proofOfSignatureDoc.types.ProofOfSignature[2] = EIP712PropertyType({
            name: 'agreementCID',
            kind: 'string'
        });
        proofOfSignatureDoc.types.ProofOfSignature[3] = EIP712PropertyType({
            name: 'app',
            kind: 'string'
        });
        proofOfSignatureDoc.types.ProofOfSignature[4] = EIP712PropertyType({
            name: 'timestamp',
            kind: 'uint256'
        });
        proofOfSignatureDoc.types.ProofOfSignature[5] = EIP712PropertyType({
            name: 'metadata',
            kind: 'string'
        });
        proofOfSignatureDoc.domain = domain;
        proofOfSignatureDoc.primaryType = 'ProofOfSignature';

        proofOfAgreementDoc.types.EIP712Domain[0] = domain0Doc;
        proofOfAgreementDoc.types.EIP712Domain[1] = domain1Doc;
        proofOfAgreementDoc.types.EIP712Domain[2] = domain2Doc;
        proofOfAgreementDoc.types.EIP712Domain[3] = domain3Doc;
        proofOfAgreementDoc.types.ProofOfAgreement[0] = EIP712PropertyType({
            name: 'agreementCID',
            kind: 'string'
        });
        proofOfAgreementDoc.types.ProofOfAgreement[1] = EIP712PropertyType({
            name: 'signatureCIDs',
            kind: 'string[]'
        });
        proofOfAgreementDoc.types.ProofOfAgreement[2] = EIP712PropertyType({
            name: 'app',
            kind: 'string'
        });
        proofOfAgreementDoc.types.ProofOfAgreement[3] = EIP712PropertyType({
            name: 'timestamp',
            kind: 'uint256'
        });
        proofOfAgreementDoc.types.ProofOfAgreement[4] = EIP712PropertyType({
            name: 'metadata',
            kind: 'string'
        });
        proofOfAgreementDoc.domain = domain;
        proofOfAgreementDoc.primaryType = 'ProofOfAgreement';
    }

    function hash(EIP712Domain memory data) internal pure returns (bytes32) {
        bytes memory encoded = abi.encode(
            EIP712DOMAIN_TYPEHASH,
            keccak256(bytes(data.name)),
            keccak256(bytes(data.version)),
            data.chainId,
            data.verifyingContract
        );
        return keccak256(encoded);
    }

    function hash(Signer memory data) internal pure returns (bytes32) {
        bytes memory encoded = abi.encode(
            SIGNER_TYPEHASH,
            data.addr,
            keccak256(bytes(data.metadata))
        );
        return keccak256(encoded);
    }

    function hash(Signer[] memory data) internal pure returns (bytes32) {
        bytes memory encoded;
        for (uint i = 0; i < data.length; i++) {
            encoded = abi.encodePacked(encoded, hash(data[i]));
        }
        return keccak256(encoded);
    }

    function hash(ProofOfAuthority memory data) internal pure returns (bytes32) {
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
        return keccak256(encoded);
    }

    function hash(ProofOfSignature memory data) internal pure returns (bytes32) {
        bytes memory encoded = abi.encode(
            PROOF_OF_SIGNATURE_TYPEHASH,
            keccak256(bytes(data.name)),
            data.signer,
            keccak256(bytes(data.agreementCID)),
            keccak256(bytes(data.app)),
            data.timestamp,
            keccak256(bytes(data.metadata))
        );
        return keccak256(encoded);
    }

    function hash(string[] memory data) internal pure returns (bytes32) {
        bytes memory encoded;
        for (uint i = 0; i < data.length; i++) {
            encoded = abi.encodePacked(encoded, keccak256(bytes(data[i])));
        }
        return keccak256(encoded);
    }

    function hash(ProofOfAgreement memory data) internal pure returns (bytes32) {
        bytes memory encoded = abi.encode(
            PROOF_OF_AGREEMENT_TYPEHASH,
            keccak256(bytes(data.agreementCID)),
            hash(data.signatureCIDs),
            keccak256(bytes(data.app)),
            data.timestamp,
            keccak256(bytes(data.metadata))
        );
        return keccak256(encoded);
    }

    function recover(bytes32 message, bytes memory sig) internal pure returns (address) {
        bytes32 r;
        bytes32 s;
        uint8 v;

        // Check the signature length
        if (sig.length != 65) {
            return (address(0));
        }

        // Divide the signature in r, s and v variables
        assembly {
            r := mload(add(sig, 32))
            s := mload(add(sig, 64))
            v := byte(0, mload(add(sig, 96)))
        }
        // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
        if (v < 27) {
            v += 27;
        }

        // If the version is correct return the signer address
        if (v != 27 && v != 28) {
            return (address(0));
        } else {
            return ecrecover(message, v, r, s);
        }
    }

    function recover(
        ProofOfAuthority memory data,
        bytes memory signature
    ) internal view returns (address) {
        bytes32 packetHash = hash(data);
        bytes32 digest = keccak256(abi.encodePacked('\x19\x01', DOMAIN_HASH, packetHash));
        return recover(digest, signature);
    }

    function recover(
        ProofOfSignature memory data,
        bytes memory signature
    ) internal view returns (address) {
        bytes32 packetHash = hash(data);
        bytes32 digest = keccak256(abi.encodePacked('\x19\x01', DOMAIN_HASH, packetHash));
        return recover(digest, signature);
    }

    function recover(
        ProofOfAgreement memory data,
        bytes memory signature
    ) internal view returns (address) {
        bytes32 packetHash = hash(data);
        bytes32 digest = keccak256(abi.encodePacked('\x19\x01', DOMAIN_HASH, packetHash));
        return recover(digest, signature);
    }

    function toEIP712Message(
        ProofOfAuthority memory message
    ) internal view returns (EIP712ProofOfAuthority memory) {
        EIP712ProofOfAuthority memory doc = proofOfAuthorityDoc;
        doc.message = message;
        return doc;
    }

    function toEIP712Message(
        ProofOfSignature memory message
    ) internal view returns (EIP712ProofOfSignature memory) {
        EIP712ProofOfSignature memory doc = proofOfSignatureDoc;
        doc.message = message;
        return doc;
    }

    function toEIP712Message(
        ProofOfAgreement memory message
    ) internal view returns (EIP712ProofOfAgreement memory) {
        EIP712ProofOfAgreement memory doc = proofOfAgreementDoc;
        doc.message = message;
        return doc;
    }
}
