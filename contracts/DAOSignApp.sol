// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { DAOSignEIP712 } from './DAOSignEIP712.sol';

contract DAOSignApp is DAOSignEIP712 {
    uint256 internal constant IPFS_CID_LENGHT = 46;

    mapping(string => SignedProofOfAuthority) internal poaus;
    mapping(string => SignedProofOfSignature) internal posis;
    mapping(string => SignedProofOfAgreement) internal poags;
    mapping(string => address) internal proof2signer;
    mapping(string => mapping(address => uint256)) internal poauSignersIdx;

    event NewProofOfAuthority(SignedProofOfAuthority indexed data);
    event NewProofOfSignature(SignedProofOfSignature indexed data);
    event NewProofOfAgreement(SignedProofOfAgreement indexed data);

    struct SignedProofOfAuthority {
        ProofOfAuthority message;
        bytes signature;
        string proofCID;
    }

    struct SignedProofOfAuthorityMsg {
        EIP712ProofOfAuthority message;
        bytes signature;
    }

    struct SignedProofOfSignature {
        ProofOfSignature message;
        bytes signature;
        string proofCID;
    }

    struct SignedProofOfSignatureMsg {
        EIP712ProofOfSignature message;
        bytes signature;
    }

    struct SignedProofOfAgreement {
        ProofOfAgreement message;
        bytes signature;
        string proofCID;
    }

    struct SignedProofOfAgreementMsg {
        EIP712ProofOfAgreement message;
        bytes signature;
    }

    constructor() {
        domain.name = 'daosign';
        domain.version = '0.1.0';
        DOMAIN_HASH = hash(domain);
        initEIP712Types();
    }

    function memcmp(bytes memory a, bytes memory b) internal pure returns (bool) {
        return (a.length == b.length) && (keccak256(a) == keccak256(b));
    }

    function strcmp(string memory a, string memory b) internal pure returns (bool) {
        return memcmp(bytes(a), bytes(b));
    }

    function validate(SignedProofOfAuthority memory data) internal pure returns (bool) {
        require(bytes(data.proofCID).length == IPFS_CID_LENGHT, 'Invalid proof CID');
        require(strcmp(data.message.app, 'daosign'), 'Invalid app name');
        require(strcmp(data.message.name, 'Proof-of-Authority'), 'Invalid struct name');
        require(bytes(data.message.agreementCID).length == IPFS_CID_LENGHT, 'Invalid CID length');
        for (uint256 i = 0; i < data.message.signers.length; i++) {
            require(data.message.signers[i].addr != address(0), 'Invalid signer');
        }
        return true;
    }

    function validate(SignedProofOfSignature memory data) internal view returns (bool) {
        require(bytes(data.proofCID).length == IPFS_CID_LENGHT, 'Invalid proof CID');
        require(strcmp(data.message.app, 'daosign'), 'Invalid app name');
        require(strcmp(data.message.name, 'Proof-of-Signature'), 'Invalid struct name');

        uint i = poauSignersIdx[data.message.agreementCID][data.message.signer];
        require(
            poaus[data.message.agreementCID].message.signers[i].addr == data.message.signer,
            'Invalid signer'
        );

        return true;
    }

    function validate(SignedProofOfAgreement memory data) internal view returns (bool) {
        require(bytes(data.proofCID).length == IPFS_CID_LENGHT, 'Invalid proof CID');
        require(strcmp(data.message.app, 'daosign'), 'Invalid app name');
        require(
            strcmp(poaus[data.message.agreementCID].message.name, 'Proof-of-Authority'),
            'Invalid agreementCID'
        );
        require(
            poaus[data.message.agreementCID].message.signers.length ==
                data.message.signatureCIDs.length,
            'Invalid sign proofs'
        );
        for (uint i = 0; i < data.message.signatureCIDs.length; i++) {
            uint idx = poauSignersIdx[data.message.agreementCID][
                posis[data.message.signatureCIDs[i]].message.signer
            ];
            require(
                poaus[data.message.agreementCID].message.signers[idx].addr ==
                    posis[data.message.signatureCIDs[i]].message.signer,
                'Invalid sign proofs'
            );
        }
        return true;
    }

    function storeProofOfAuthority(SignedProofOfAuthority memory data) external {
        require(recover(data.message, data.signature) == data.message.from, 'Invalid signature');
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
        require(recover(data.message, data.signature) == data.message.signer, 'Invalid signature');
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

    function getProofOfAuthority(
        string memory cid
    ) external view returns (SignedProofOfAuthorityMsg memory) {
        SignedProofOfAuthority memory data = poaus[cid];
        return
            SignedProofOfAuthorityMsg({
                message: toEIP712Message(data.message),
                signature: data.signature
            });
    }

    function getProofOfSignature(
        string memory cid
    ) external view returns (SignedProofOfSignatureMsg memory) {
        SignedProofOfSignature memory data = posis[cid];
        return
            SignedProofOfSignatureMsg({
                message: toEIP712Message(data.message),
                signature: data.signature
            });
    }

    function getProofOfAgreement(
        string memory cid
    ) external view returns (SignedProofOfAgreementMsg memory) {
        SignedProofOfAgreement memory data = poags[cid];
        return
            SignedProofOfAgreementMsg({
                message: toEIP712Message(data.message),
                signature: data.signature
            });
    }
}
