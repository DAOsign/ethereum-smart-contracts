// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { EIP712Domain, hash } from '../messages/domain.sol';
import { ProofOfAuthority, EIP712ProofOfAuthorityDocument, IEIP721ProofOfAuthority } from '../messages/proof_of_authority.sol';
import { ProofOfSignature, EIP712ProofOfSignatureDocument, IEIP712ProofOfSignature } from '../messages/proof_of_signature.sol';
import { ProofOfAgreement, EIP712ProofOfAgreementDocument, IEIP712ProofOfAgreement } from '../messages/proof_of_agreement.sol';
import { ProofOfVoid, EIP712ProofOfVoidDocument, IEIP712ProofOfVoid } from '../messages/proof_of_void.sol';

contract MockDAOSignEIP712 {
    EIP712Domain internal domain;
    bytes32 internal domainHash;

    IEIP721ProofOfAuthority internal proofOfAuthority;
    IEIP712ProofOfSignature internal proofOfSignature;
    IEIP712ProofOfAgreement internal proofOfAgreement;
    IEIP712ProofOfVoid internal proofOfVoid;

    constructor(
        EIP712Domain memory _domain,
        address _proofOfAuthority,
        address _proofOfSignature,
        address _proofOfAgreement,
        address _proofOfVoid
    ) {
        domain = _domain;
        domainHash = hash(_domain);
        proofOfAuthority = IEIP721ProofOfAuthority(_proofOfAuthority);
        proofOfSignature = IEIP712ProofOfSignature(_proofOfSignature);
        proofOfAgreement = IEIP712ProofOfAgreement(_proofOfAgreement);
        proofOfVoid = IEIP712ProofOfVoid(_proofOfVoid);
    }

    function getDomainHash() public view returns (bytes32) {
        return domainHash;
    }

    function getProofOfAuthorityMessage(
        ProofOfAuthority memory message
    ) public view returns (EIP712ProofOfAuthorityDocument memory) {
        return proofOfAuthority.toEIP712Message(domain, message);
    }

    function getProofOfSignatureMessage(
        ProofOfSignature memory message
    ) public view returns (EIP712ProofOfSignatureDocument memory) {
        return proofOfSignature.toEIP712Message(domain, message);
    }

    function getProofOfAgreementMessage(
        ProofOfAgreement memory message
    ) public view returns (EIP712ProofOfAgreementDocument memory) {
        return proofOfAgreement.toEIP712Message(domain, message);
    }

    function getProofOfVoidtMessage(
        ProofOfVoid memory message
    ) public view returns (EIP712ProofOfVoidDocument memory) {
        return proofOfVoid.toEIP712Message(domain, message);
    }

    function hashProofOfAuthority(ProofOfAuthority memory message) public view returns (bytes32) {
        return proofOfAuthority.hash(message);
    }

    function hashProofOfSignature(ProofOfSignature memory message) public view returns (bytes32) {
        return proofOfSignature.hash(message);
    }

    function hashProofOfAgreement(ProofOfAgreement memory message) public view returns (bytes32) {
        return proofOfAgreement.hash(message);
    }

    function hashProofOfVoid(ProofOfVoid memory message) public view returns (bytes32) {
        return proofOfVoid.hash(message);
    }

    function recoverProofOfAuthority(
        ProofOfAuthority memory message,
        bytes memory signature
    ) public view returns (address) {
        return proofOfAuthority.recover(domainHash, message, signature);
    }

    function recoverProofOfSignature(
        ProofOfSignature memory message,
        bytes memory signature
    ) public view returns (address) {
        return proofOfSignature.recover(domainHash, message, signature);
    }

    function recoverProofOfAgreement(
        ProofOfAgreement memory message,
        bytes memory signature
    ) public view returns (address) {
        return proofOfAgreement.recover(domainHash, message, signature);
    }

    function recoverProofOfVoid(
        ProofOfVoid memory message,
        bytes memory signature
    ) public view returns (address) {
        return proofOfVoid.recover(domainHash, message, signature);
    }
}
