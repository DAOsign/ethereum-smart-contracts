// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { ProofOfAuthority, EIP712ProofOfAuthority, ProofOfSignature, EIP712ProofOfSignature, ProofOfAgreement, EIP712ProofOfAgreement } from '../DAOSignEIP712.sol';

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
    string proofCID;
}

struct SignedProofOfAgreementMsg {
    EIP712ProofOfAgreement message;
}

interface IDAOSignApp {
    event NewProofOfAuthority(SignedProofOfAuthority indexed data);
    event NewProofOfSignature(SignedProofOfSignature indexed data);
    event NewProofOfAgreement(SignedProofOfAgreement indexed data);

    function getProofOfAuthority(
        string memory cid
    ) external view returns (SignedProofOfAuthorityMsg memory);

    function getProofOfSignature(
        string memory cid
    ) external view returns (SignedProofOfSignatureMsg memory);

    function getProofOfAgreement(
        string memory cid
    ) external view returns (SignedProofOfAgreementMsg memory);

    function storeProofOfAuthority(SignedProofOfAuthority memory data) external;

    function storeProofOfSignature(SignedProofOfSignature memory data) external;

    function storeProofOfAgreement(SignedProofOfAgreement memory data) external;
}
