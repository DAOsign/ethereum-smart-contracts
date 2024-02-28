// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { SignedProofOfAuthority, SignedProofOfSignature, SignedProofOfAgreement, DAOSignApp } from '../DAOSignApp.sol';

contract MockDAOSignApp is DAOSignApp {
    constructor(
        address _proofOfAuthority,
        address _proofOfSignature,
        address _proofOfAgreement,
        address _proofOfVoid,
        address _proofOfCancel,
        address _tradeFI
    )
        DAOSignApp(
            _proofOfAuthority,
            _proofOfSignature,
            _proofOfAgreement,
            _proofOfVoid,
            _proofOfCancel,
            _tradeFI
        )
    {}

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

    function onlyStoreProofOfAuthority(SignedProofOfAuthority memory data) external {
        poaus[data.proofCID].message.name = data.message.name;
        poaus[data.proofCID].message.from = data.message.from;
        poaus[data.proofCID].message.agreementCID = data.message.agreementCID;
        poaus[data.proofCID].message.timestamp = data.message.timestamp;
        poaus[data.proofCID].message.metadata = data.message.metadata;
        for (uint i = 0; i < data.message.signers.length; i++) {
            poauSignersIdx[data.proofCID][data.message.signers[i].addr] = i;
            poaus[data.proofCID].message.signers.push(data.message.signers[i]);
        }
        poaus[data.proofCID].signature = data.signature;
        poaus[data.proofCID].proofCID = data.proofCID;
        proof2signer[data.proofCID] = data.message.from;
    }

    function onlyStoreProofOfSignature(SignedProofOfSignature memory data) external {
        posis[data.proofCID] = data;
        proof2signer[data.proofCID] = data.message.signer;
    }
}
