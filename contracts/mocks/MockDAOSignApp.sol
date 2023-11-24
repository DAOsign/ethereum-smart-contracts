// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { DAOSignApp } from '../DAOSignApp.sol';

contract MockDAOSignApp is DAOSignApp {
    function validateProofOfAuthority(
        SignedProofOfAuthority memory data
    ) public pure returns (bool) {
        return validate(data);
    }

    function validateProofOfSignature(
        SignedProofOfSignature memory data
    ) public view returns (bool) {
        return validate(data);
    }

    function validateProofOfAgreement(
        SignedProofOfAgreement memory data
    ) public view returns (bool) {
        return validate(data);
    }
}
