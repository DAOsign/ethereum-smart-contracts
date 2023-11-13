// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { Ownable } from '@openzeppelin/contracts/access/Ownable.sol';

/* * * * * * *
 * DAOSign EIP712 types
 * {
 *   domain: {
 *     name: "daosign",
 *     version: "0.1.0",
 *   },
 *   types: {
 *     EIP712Domain: [
 *       { name: "name", type: "string" },
 *       { name: "version", type: "string" },
 *       { name: "chainId", type: "uint256" },
 *       { name: "verifyingContract", type: "address" },
 *     ],
 *     Signer: [
 *       { name: "addr", type: "address" },
 *       { name: "metadata", type: "string" },
 *     ],
 *     Metadata: [
 *       { name: "app", type: "string" },
 *       { name: "structure", type: "string" },
 *       { name: "timestamp", type: "uint256" },
 *       { name: "metadata", type: "string" },
 *     ],
 *     ProofOfAuthorityMsg: [
 *       { name: "from", type: "address" },
 *       { name: "agreementCID", type: "string" },
 *       { name: "signers", type: "Signer[]" },
 *       { name: "metadata", type: "Metadata" },
 *     ],
 *     ProofOfSignatureMsg: [
 *       { "name": "signer", "type": "address" },
 *       { "name": "agreementCID", "type": "string" },
 *       { "name": "metadata", "type": "Metadata" },
 *     ],
 *     ProofOfAgreementMsg: [
 *       { "name": "agreementCID", "type": "string" },
 *       { "name": "signatureCIDs", "type": "string[]" },
 *       { "name": "metadata", "type": "Metadata" }
 *     ],
 *   },
 * }
 * */

bytes32 constant EIP712DOMAIN_TYPEHASH = keccak256(
    'EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'
);

struct EIP712Domain {
    string name;
    string version;
    uint256 chainId;
    address verifyingContract;
}

bytes32 constant SIGNER_TYPEHASH = keccak256('Signer(address addr,string metadata)');

struct Signer {
    address addr;
    string metadata;
}

bytes32 constant METADATA_TYPEHASH = keccak256(
    'Metadata(string app,string structure,uint256 timestamp,string metadata)'
);

struct Metadata {
    string app;
    string structure;
    uint256 timestamp;
    string metadata;
}

bytes32 constant PROOF_AUTHORITY_MSG_TYPEHASH = keccak256(
    'ProofOfAuthorityMsg(address from,string agreementCID,Signer[] signers,Metadata metadata)Metadata(string app,string structure,uint256 timestamp,string metadata)Signer(address addr,string metadata)'
);

struct ProofOfAuthorityMsg {
    address from;
    string agreementCID;
    Signer[] signers;
    Metadata metadata;
}

bytes32 constant PROOF_SIGNATURE_MSG_TYPEHASH = keccak256(
    'ProofOfSignatureMsg(address signer,string agreementCID,Metadata metadata)Metadata(string app,string structure,uint256 timestamp,string metadata)'
);

struct ProofOfSignatureMsg {
    address signer;
    string agreementCID;
    Metadata metadata;
}

bytes32 constant PROOF_AGREEMENT_MSG_TYPEHASH = keccak256(
    'ProofOfAgreementMsg(string agreementCID,string[] signatureCIDs,Metadata metadata)Metadata(string app,string structure,uint256 timestamp,string metadata)'
);

struct ProofOfAgreementMsg {
    string agreementCID;
    string[] signatureCIDs;
    Metadata metadata;
}

abstract contract DAOSignDecoder {
    bytes32 DOMAIN_HASH;

    function getDomainHash() public view returns (bytes32) {
        return DOMAIN_HASH;
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

    function hash(Metadata memory data) internal pure returns (bytes32) {
        bytes memory encoded = abi.encode(
            METADATA_TYPEHASH,
            keccak256(bytes(data.app)),
            keccak256(bytes(data.structure)),
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

    function hash(ProofOfAuthorityMsg memory data) internal pure returns (bytes32) {
        bytes memory encoded = abi.encode(
            PROOF_AUTHORITY_MSG_TYPEHASH,
            data.from,
            keccak256(bytes(data.agreementCID)),
            hash(data.signers),
            hash(data.metadata)
        );
        return keccak256(encoded);
    }

    function hash(ProofOfSignatureMsg memory data) internal pure returns (bytes32) {
        bytes memory encoded = abi.encode(
            PROOF_SIGNATURE_MSG_TYPEHASH,
            data.signer,
            keccak256(bytes(data.agreementCID)),
            hash(data.metadata)
        );
        return keccak256(encoded);
    }

    function hash(ProofOfAgreementMsg memory data) internal pure returns (bytes32) {
        bytes memory encoded = abi.encode(
            PROOF_AGREEMENT_MSG_TYPEHASH,
            keccak256(bytes(data.agreementCID)),
            hash(data.signatureCIDs),
            hash(data.metadata)
        );
        return keccak256(encoded);
    }

    function recover(bytes32 message, bytes memory signature) internal pure returns (address) {
        bytes32 r;
        bytes32 s;
        uint8 v;

        // Check the signature length
        if (signature.length != 65) {
            return (address(0));
        }

        // Divide the signature in r, s and v variables
        assembly {
            r := mload(add(signature, 32))
            s := mload(add(signature, 64))
            v := byte(0, mload(add(signature, 96)))
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
        ProofOfAuthorityMsg memory message,
        bytes memory signature
    ) internal view returns (address) {
        bytes32 packetHash = hash(message);
        bytes32 digest = keccak256(abi.encodePacked('\x19\x01', DOMAIN_HASH, packetHash));
        return recover(digest, signature);
    }

    function recover(
        ProofOfSignatureMsg memory message,
        bytes memory signature
    ) internal view returns (address) {
        bytes32 packetHash = hash(message);
        bytes32 digest = keccak256(abi.encodePacked('\x19\x01', DOMAIN_HASH, packetHash));
        return recover(digest, signature);
    }

    function recover(
        ProofOfAgreementMsg memory message,
        bytes memory signature
    ) internal view returns (address) {
        bytes32 packetHash = hash(message);
        bytes32 digest = keccak256(abi.encodePacked('\x19\x01', DOMAIN_HASH, packetHash));
        return recover(digest, signature);
    }
}

struct SignedProofOfAuthorityMsg {
    ProofOfAuthorityMsg message;
    bytes signature;
    string proofCID;
}

struct SignedProofOfSignatureMsg {
    ProofOfSignatureMsg message;
    bytes signature;
    string proofCID;
}

struct SignedProofOfAgreementMsg {
    ProofOfAgreementMsg message;
    string proofCID;
}

uint constant IPFS_CID_LENGHT = 46;

interface DAOSignApp {
    event NewProofOfAuthorityMsg(SignedProofOfAuthorityMsg indexed data);
    event NewProofOfSignatureMsg(SignedProofOfSignatureMsg indexed data);
    event NewProofOfAgreementMsg(SignedProofOfAgreementMsg indexed data);

    function getProofOfAuthority(
        string memory cid
    ) external view returns (SignedProofOfAuthorityMsg memory);

    function getProofOfSignature(
        string memory cid
    ) external view returns (SignedProofOfSignatureMsg memory);

    function getProofOfAgreement(
        string memory cid
    ) external view returns (SignedProofOfAgreementMsg memory);

    function storeProofOfAuthority(SignedProofOfAuthorityMsg memory data) external;

    function storeProofOfSignature(SignedProofOfSignatureMsg memory data) external;

    function storeProofOfAgreement(SignedProofOfAgreementMsg memory data) external;
}

abstract contract DAOSignBaseApp is DAOSignDecoder, DAOSignApp {
    // Link from Proof-of-Authority CID to the Proof-of-Signature CIDs
    mapping(string => string[]) proofsOfSignatureCIDs;

    // Link from any proof CID to the proof itself
    mapping(string => bytes) proofs;

    function memcmp(bytes memory a, bytes memory b) internal pure returns (bool) {
        return (a.length == b.length) && (keccak256(a) == keccak256(b));
    }

    function strcmp(string memory a, string memory b) internal pure returns (bool) {
        return memcmp(bytes(a), bytes(b));
    }

    function validate(Metadata memory data, string memory structure) internal view returns (bool) {
        require(strcmp(data.app, 'daosign'), 'Invalid struct name');
        require(strcmp(data.structure, structure), 'Invalid struct name');
        // TODO: 3 hours ???
        require(
            block.timestamp - 3 hours <= data.timestamp && data.timestamp <= block.timestamp,
            'Invalid timestamp'
        );
        return true;
    }

    function validate(SignedProofOfAuthorityMsg memory data) internal view returns (bool) {
        require(validate(data.message.metadata, 'Proof-of-Authority'), 'Invalid metadata');
        require(bytes(data.proofCID).length == IPFS_CID_LENGHT, 'Invalid proof CID');
        require(bytes(data.message.agreementCID).length == IPFS_CID_LENGHT, 'Invalid CID length');
        for (uint256 i = 0; i < data.message.signers.length; i++) {
            require(data.message.signers[i].addr != address(0), 'Invalid signer');
        }
        return true;
    }

    function validate(SignedProofOfSignatureMsg memory data) internal view returns (bool) {
        require(validate(data.message.metadata, 'Proof-of-Signature'), 'Invalid metadata');
        require(bytes(data.proofCID).length == IPFS_CID_LENGHT, 'Invalid proof CID');
        Signer[] memory signers = abi
            .decode(proofs[data.message.agreementCID], (SignedProofOfAuthorityMsg))
            .message
            .signers;
        for (uint256 i = 0; i < signers.length; i++) {
            if (signers[i].addr == data.message.signer) return true;
        }
        return true;
    }

    function validate(SignedProofOfAgreementMsg memory data) internal view returns (bool) {
        require(validate(data.message.metadata, 'Proof-of-Agreement'), 'Invalid metadata');
        require(bytes(data.proofCID).length == IPFS_CID_LENGHT, 'Invalid proof CID');

        uint256 numSigsExpected = proofsOfSignatureCIDs[data.message.agreementCID].length;
        require(
            numSigsExpected == data.message.signatureCIDs.length,
            'Invalid number of Proofs-of-Signature'
        );

        uint256 numSigsFound = 0;
        for (uint256 i = 0; i < numSigsExpected; i++) {
            for (uint256 j = 0; j < numSigsExpected; j++) {
                if (
                    strcmp(
                        proofsOfSignatureCIDs[data.message.agreementCID][i],
                        data.message.signatureCIDs[j]
                    )
                ) {
                    numSigsFound++;
                }
            }
        }
        require(numSigsFound == numSigsExpected, 'Invalid Proofs-of-Signature');
        return true;
    }

    function getProofOfAuthority(
        string memory cid
    ) external view returns (SignedProofOfAuthorityMsg memory) {
        return abi.decode(proofs[cid], (SignedProofOfAuthorityMsg));
    }

    function getProofOfSignature(
        string memory cid
    ) external view returns (SignedProofOfSignatureMsg memory) {
        return abi.decode(proofs[cid], (SignedProofOfSignatureMsg));
    }

    function getProofOfAgreement(
        string memory cid
    ) external view returns (SignedProofOfAgreementMsg memory) {
        return abi.decode(proofs[cid], (SignedProofOfAgreementMsg));
    }

    function storeProofOfAuthority(SignedProofOfAuthorityMsg memory data) external {
        require(recover(data.message, data.signature) == data.message.from, 'Invalid signature');
        require(validate(data), 'Invalid message');
        proofs[data.proofCID] = abi.encode(data);
        emit NewProofOfAuthorityMsg(data);
    }

    function storeProofOfSignature(SignedProofOfSignatureMsg memory data) external {
        require(recover(data.message, data.signature) == data.message.signer, 'Invalid signature');
        require(validate(data), 'Invalid message');
        proofs[data.proofCID] = abi.encode(data);
        emit NewProofOfSignatureMsg(data);
    }

    function storeProofOfAgreement(SignedProofOfAgreementMsg memory data) external {
        require(validate(data), 'Invalid message');
        proofs[data.proofCID] = abi.encode(data);
        emit NewProofOfAgreementMsg(data);
    }
}
