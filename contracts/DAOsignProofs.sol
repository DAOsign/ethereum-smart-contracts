// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { Proofs } from './Proofs.sol';

contract DAOsignProofs is Proofs {
    mapping(bytes32 => bytes) data;

    function validate(ProofOfAuthority memory) internal pure override returns (bool) {
        return true;
    }

    function validate(ProofOfSignature memory) internal pure override returns (bool) {
        return true;
    }

    function validate(ProofOfAgreement memory) internal pure override returns (bool) {
        return true;
    }

    function save(ProofOfAuthority memory message) internal override {
        data[keccak256(abi.encode(message))] = abi.encode(message);
    }

    function save(ProofOfSignature memory message) internal override {
        data[keccak256(abi.encode(message))] = abi.encode(message);
    }

    function save(ProofOfAgreement memory message) internal override {
        data[keccak256(abi.encode(message))] = abi.encode(message);
    }
}
