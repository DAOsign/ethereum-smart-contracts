// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { Proofs } from './Proofs.sol';

contract DAOsignProofs is Proofs {
    mapping(bytes32 => bytes) data;

    function validate(ProofOfAuthorityShrinked memory) internal pure override returns (bool) {
        return true;
    }

    function validate(ProofOfSignatureShrinked memory) internal pure override returns (bool) {
        return true;
    }

    function validate(ProofOfAgreementShrinked memory) internal pure override returns (bool) {
        return true;
    }

    function save(ProofOfAuthorityShrinked memory message) internal override {
        data[keccak256(abi.encode(message))] = abi.encode(message);
    }

    function save(ProofOfSignatureShrinked memory message) internal override {
        data[keccak256(abi.encode(message))] = abi.encode(message);
    }

    function save(ProofOfAgreementShrinked memory message) internal override {
        data[keccak256(abi.encode(message))] = abi.encode(message);
    }
}
