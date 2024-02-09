// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { EIP712Domain, hash } from './messages/domain.sol';
import { ProofOfAuthority, EIP712ProofOfAuthorityDocument, IEIP721ProofOfAuthority } from './messages/proof_of_authority.sol';
import { ProofOfSignature, EIP712ProofOfSignatureDocument, IEIP712ProofOfSignature } from './messages/proof_of_signature.sol';
import { ProofOfAgreement, EIP712ProofOfAgreementDocument, IEIP712ProofOfAgreement } from './messages/proof_of_agreement.sol';
import { ProofOfVoid, EIP712ProofOfVoidDocument, IEIP712ProofOfVoid } from './messages/proof_of_void.sol';
import { ITradeFI } from './interfaces/ITradeFI.sol';

struct SignedProofOfAuthority {
    ProofOfAuthority message;
    bytes signature;
    string proofCID;
}

struct SignedProofOfAuthorityMsg {
    EIP712ProofOfAuthorityDocument message;
    bytes signature;
}

struct SignedProofOfSignature {
    ProofOfSignature message;
    bytes signature;
    string proofCID;
}

struct SignedProofOfSignatureMsg {
    EIP712ProofOfSignatureDocument message;
    bytes signature;
}

struct SignedProofOfAgreement {
    ProofOfAgreement message;
    string proofCID;
}

struct SignedProofOfAgreementMsg {
    EIP712ProofOfAgreementDocument message;
}

struct SignedProofOfVoid {
    ProofOfVoid message;
    bytes signature;
    string proofCID;
}

struct SignedProofOfVoidMsg {
    EIP712ProofOfVoidDocument message;
    bytes signature;
}

interface IDAOSignApp {
    event NewProofOfAuthority(SignedProofOfAuthority indexed data);
    event NewProofOfSignature(SignedProofOfSignature indexed data);
    event NewProofOfAgreement(SignedProofOfAgreement indexed data);
    event NewProofOfVoid(SignedProofOfVoid indexed data);

    function getProofOfAuthority(
        string memory cid
    ) external view returns (SignedProofOfAuthorityMsg memory);

    function getProofOfSignature(
        string memory cid
    ) external view returns (SignedProofOfSignatureMsg memory);

    function getProofOfAgreement(
        string memory cid
    ) external view returns (SignedProofOfAgreementMsg memory);

    function getProofOfVoid(string memory cid) external view returns (SignedProofOfVoidMsg memory);

    function storeProofOfAuthority(SignedProofOfAuthority memory data) external;

    function storeProofOfSignature(SignedProofOfSignature memory data) external;

    function storeProofOfAgreement(SignedProofOfAgreement memory data) external;

    function storeProofOfVoid(SignedProofOfVoid memory data) external;
}

contract DAOSignApp is IDAOSignApp {
    uint256 internal constant IPFS_CID_LENGTH = 46;

    EIP712Domain internal domain;
    bytes32 internal domainHash;

    IEIP721ProofOfAuthority internal proofOfAuthority;
    IEIP712ProofOfSignature internal proofOfSignature;
    IEIP712ProofOfAgreement internal proofOfAgreement;
    IEIP712ProofOfVoid internal proofOfVoid;
    ITradeFI private tradeFI;

    mapping(string => SignedProofOfAuthority) internal poaus;
    mapping(string => SignedProofOfSignature) internal posis;
    mapping(string => SignedProofOfAgreement) internal poags;
    mapping(string => SignedProofOfVoid) internal pov;

    mapping(string => bool) internal voided;
    mapping(string => address) internal proof2signer;
    mapping(string => mapping(address => uint256)) internal poauSignersIdx;

    constructor(
        address _proofOfAuthority,
        address _proofOfSignature,
        address _proofOfAgreement,
        address _proofOfVoid,
        address _tradeFI
    ) {
        domain = EIP712Domain({
            name: 'daosign',
            version: '0.1.0',
            chainId: 1,
            verifyingContract: address(0)
        });
        domainHash = hash(domain);
        proofOfAuthority = IEIP721ProofOfAuthority(_proofOfAuthority);
        proofOfSignature = IEIP712ProofOfSignature(_proofOfSignature);
        proofOfAgreement = IEIP712ProofOfAgreement(_proofOfAgreement);
        proofOfVoid = IEIP712ProofOfVoid(_proofOfVoid);
        tradeFI = ITradeFI(_tradeFI);
    }

    function storeProofOfAuthority(SignedProofOfAuthority memory data) external {
        require(
            proofOfAuthority.recover(domainHash, data.message, data.signature) == data.message.from,
            'Invalid signature'
        );
        require(validate(data), 'Invalid message');

        poaus[data.proofCID].message.name = data.message.name;
        poaus[data.proofCID].message.from = data.message.from;
        poaus[data.proofCID].message.agreementCID = data.message.agreementCID;
        poaus[data.proofCID].message.app = data.message.app;
        poaus[data.proofCID].message.timestamp = data.message.timestamp;
        poaus[data.proofCID].message.metadata = data.message.metadata;
        for (uint i = 0; i < data.message.signers.length; i++) {
            poauSignersIdx[data.proofCID][data.message.signers[i].addr] = i;
            poaus[data.proofCID].message.signers.push(data.message.signers[i]);
        }
        poaus[data.proofCID].signature = data.signature;
        poaus[data.proofCID].proofCID = data.proofCID;
        proof2signer[data.proofCID] = data.message.from;
        emit NewProofOfAuthority(data);
    }

    function storeProofOfSignature(SignedProofOfSignature memory data) external {
        require(
            proofOfSignature.recover(domainHash, data.message, data.signature) ==
                data.message.signer,
            'Invalid signature'
        );
        require(validate(data), 'Invalid message');

        posis[data.proofCID] = data;
        proof2signer[data.proofCID] = data.message.signer;
        emit NewProofOfSignature(data);
    }

    function storeProofOfAgreement(SignedProofOfAgreement memory data) external {
        require(validate(data), 'Invalid message');

        poags[data.proofCID] = data;
        emit NewProofOfAgreement(data);
    }

    function storeProofOfVoid(SignedProofOfVoid memory data) external {
        require(
            proofOfVoid.recover(domainHash, data.message, data.signature) == tradeFI.getAdmin(),
            'Invalid signature'
        );
        require(validate(data), 'Invalid message');

        pov[data.proofCID] = data;
        voided[data.message.authorityCID] = true;
        emit NewProofOfVoid(data);
    }

    function getProofOfAuthority(
        string memory cid
    ) external view returns (SignedProofOfAuthorityMsg memory) {
        SignedProofOfAuthority memory data = poaus[cid];
        return
            SignedProofOfAuthorityMsg({
                message: proofOfAuthority.toEIP712Message(domain, data.message),
                signature: data.signature
            });
    }

    function getProofOfSignature(
        string memory cid
    ) external view returns (SignedProofOfSignatureMsg memory) {
        SignedProofOfSignature memory data = posis[cid];
        return
            SignedProofOfSignatureMsg({
                message: proofOfSignature.toEIP712Message(domain, data.message),
                signature: data.signature
            });
    }

    function getProofOfAgreement(
        string memory cid
    ) external view returns (SignedProofOfAgreementMsg memory) {
        SignedProofOfAgreement memory data = poags[cid];
        return
            SignedProofOfAgreementMsg({
                message: proofOfAgreement.toEIP712Message(domain, data.message)
            });
    }

    function getProofOfVoid(string memory cid) external view returns (SignedProofOfVoidMsg memory) {
        SignedProofOfVoid memory data = pov[cid];
        return
            SignedProofOfVoidMsg({
                message: proofOfVoid.toEIP712Message(domain, data.message),
                signature: data.signature
            });
    }

    function memcmp(bytes memory a, bytes memory b) internal pure returns (bool) {
        return (a.length == b.length) && (keccak256(a) == keccak256(b));
    }

    function strcmp(string memory a, string memory b) internal pure returns (bool) {
        return memcmp(bytes(a), bytes(b));
    }

    function validate(SignedProofOfAuthority memory data) internal pure returns (bool) {
        require(bytes(data.proofCID).length == IPFS_CID_LENGTH, 'Invalid proof CID');
        require(strcmp(data.message.app, 'daosign'), 'Invalid app name');
        require(strcmp(data.message.name, 'Proof-of-Authority'), 'Invalid proof name');
        require(
            bytes(data.message.agreementCID).length == IPFS_CID_LENGTH,
            'Invalid agreement CID'
        );
        for (uint256 i = 0; i < data.message.signers.length; i++) {
            require(data.message.signers[i].addr != address(0), 'Invalid signer');
        }
        return true;
    }

    function validate(SignedProofOfSignature memory data) internal view returns (bool) {
        require(bytes(data.proofCID).length == IPFS_CID_LENGTH, 'Invalid proof CID');
        require(strcmp(data.message.app, 'daosign'), 'Invalid app name');
        require(strcmp(data.message.name, 'Proof-of-Signature'), 'Invalid proof name');
        require(!voided[data.message.authorityCID], 'ProofOfAuthority voided');

        uint i = poauSignersIdx[data.message.authorityCID][data.message.signer];
        require(
            poaus[data.message.authorityCID].message.signers[i].addr == data.message.signer,
            'Invalid signer'
        );

        return true;
    }

    function validate(SignedProofOfAgreement memory data) internal view returns (bool) {
        require(bytes(data.proofCID).length == IPFS_CID_LENGTH, 'Invalid proof CID');
        require(strcmp(data.message.app, 'daosign'), 'Invalid app name');
        require(
            strcmp(poaus[data.message.authorityCID].message.name, 'Proof-of-Authority'),
            'Invalid Proof-of-Authority name'
        );
        require(
            poaus[data.message.authorityCID].message.signers.length ==
                data.message.signatureCIDs.length,
            'Invalid Proofs-of-Signatures length'
        );
        require(!voided[data.message.authorityCID], 'ProofOfAuthority voided');

        for (uint i = 0; i < data.message.signatureCIDs.length; i++) {
            uint idx = poauSignersIdx[data.message.authorityCID][
                posis[data.message.signatureCIDs[i]].message.signer
            ];
            require(
                poaus[data.message.authorityCID].message.signers[idx].addr ==
                    posis[data.message.signatureCIDs[i]].message.signer,
                'Invalid Proofs-of-Signature signer'
            );
        }
        return true;
    }

    function validate(SignedProofOfVoid memory data) internal view returns (bool) {
        require(bytes(data.proofCID).length == IPFS_CID_LENGTH, 'Invalid proof CID');
        require(strcmp(data.message.app, 'daosign'), 'Invalid app name');
        require(
            strcmp(poaus[data.message.authorityCID].message.name, 'Proof-of-Authority'),
            'Invalid Proof-of-Authority name'
        );

        return true;
    }
}
