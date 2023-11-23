// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { DAOSignEIP712 } from '../DAOSignEIP712.sol';

contract MockDAOSignEIP712 is DAOSignEIP712 {
    constructor(EIP712Domain memory _domain) {
        domain = _domain;
        DOMAIN_HASH = hash(_domain);
        initEIP712Types();
    }

    function getDomainHash() public view returns (bytes32) {
        return DOMAIN_HASH;
    }

    function getProofOfAuthorityMessage(
        ProofOfAuthority memory message
    ) public view returns (EIP712ProofOfAuthority memory) {
        return toEIP712Message(message);
    }

    function getProofOfSignatureMessage(
        ProofOfSignature memory message
    ) public view returns (EIP712ProofOfSignature memory) {
        return toEIP712Message(message);
    }

    function getProofOfAgreementMessage(
        ProofOfAgreement memory message
    ) public view returns (EIP712ProofOfAgreement memory) {
        return toEIP712Message(message);
    }

    function hashProofOfAuthority(ProofOfAuthority memory message) public pure returns (bytes32) {
        return hash(message);
    }

    function hashProofOfSignature(ProofOfSignature memory message) public pure returns (bytes32) {
        return hash(message);
    }

    function hashProofOfAgreement(ProofOfAgreement memory message) public pure returns (bytes32) {
        return hash(message);
    }

    function recoverProofOfAuthority(
        ProofOfAuthority memory message,
        bytes memory signature
    ) public view returns (address) {
        return recover(message, signature);
    }

    function recoverProofOfSignature(
        ProofOfSignature memory message,
        bytes memory signature
    ) public view returns (address) {
        return recover(message, signature);
    }

    function recoverProofOfAgreement(
        ProofOfAgreement memory message,
        bytes memory signature
    ) public view returns (address) {
        return recover(message, signature);
    }
}
