// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { Proofs } from './Proofs.sol';
import { StringUtils } from './lib/StringUtils.sol';

contract DAOsignProofs is Proofs {
    using StringUtils for string;

    mapping(string => bytes) public proofs;

    function getProofOfAuthority(
        string memory _proofCID
    ) public view override returns (ProofOfAuthorityShrinked memory) {
        return abi.decode(proofs[_proofCID], (ProofOfAuthorityShrinked));
    }

    function getProofOfSignature(
        string memory _proofCID
    ) public view override returns (ProofOfSignatureShrinked memory) {
        return abi.decode(proofs[_proofCID], (ProofOfSignatureShrinked));
    }

    function getProofOfAgreement(
        string memory _proofCID
    ) public view override returns (ProofOfAgreement memory) {
        return abi.decode(proofs[_proofCID], (ProofOfAgreement));
    }

    function _validate(
        ProofOfAuthorityShrinked memory _proof
    ) internal view override returns (bool) {
        require(_proof.version.length() > 0, 'Invalid version');
        require(_proof.message.name.equal('Proof-of-Authority'), 'Invalid name');
        require(_proof.message.agreementFileCID.length() == 46, 'Invalid CID length');
        require(_proof.message.app.equal('daosign'), 'Invalid app');
        require(
            _proof.message.timestamp <= block.timestamp &&
                _proof.message.timestamp >= block.timestamp - 3 hours,
            'Invalid timestamp'
        );

        for (uint256 i = 0; i < _proof.message.signers.length; i++) {
            require(_proof.message.signers[i].addr != address(0), 'Invalid signer');
        }

        return true;
    }

    function _validate(
        ProofOfSignatureShrinked memory _proof
    ) internal view override returns (bool) {
        require(_proof.version.length() > 0, 'Invalid version');
        require(_proof.message.name.equal('Proof-of-Signature'), 'Invalid name');
        require(_proof.message.agreementFileProofCID.length() == 46, 'Invalid CID length');
        require(_proof.message.app.equal('daosign'), 'Invalid app');
        require(
            _proof.message.timestamp <= block.timestamp &&
                _proof.message.timestamp >= block.timestamp - 3 hours,
            'Invalid timestamp'
        );

        return true;
    }

    function _validate(ProofOfAgreement memory _proof) internal view override returns (bool) {
        require(_proof.agreementFileProofCID.length() == 46, 'Invalid Proof-of-Authority CID');
        for (uint256 i = 0; i < _proof.agreementSignProofs.length; i++) {
            require(
                _proof.agreementSignProofs[i].proofCID.length() == 46,
                'Invalid Proof-of-Signature CID'
            );
        }
        require(
            _proof.timestamp <= block.timestamp && _proof.timestamp >= block.timestamp - 3 hours,
            'Invalid timestamp'
        );
        return true;
    }

    function _store(
        ProofOfAuthorityShrinked memory _proof,
        string memory _proofCID
    ) internal override {
        proofs[_proofCID] = abi.encode(
            ProofOfAuthorityShrinked(_proof.sig, _proof.version, _proof.message)
        );
        emit NewProofOfAuthority(_proof);
    }

    function _store(
        ProofOfSignatureShrinked memory _proof,
        string memory _proofCID
    ) internal override {
        proofs[_proofCID] = abi.encode(
            ProofOfSignatureShrinked(_proof.sig, _proof.version, _proof.message)
        );
        emit NewProofOfSignature(_proof);
    }

    function _store(ProofOfAgreement memory _proof, string memory _proofCID) internal override {
        proofs[_proofCID] = abi.encode(
            ProofOfAgreement(
                _proof.agreementFileProofCID,
                _proof.agreementSignProofs,
                _proof.timestamp,
                _proof.metadata
            )
        );
        emit NewProofOfAgreement(_proof);
    }
}
