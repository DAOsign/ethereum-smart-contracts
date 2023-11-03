// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { Proofs } from './Proofs.sol';
import { StringUtils } from './lib/StringUtils.sol';

// TODO: make upgradeable
contract DAOsignProofs is Proofs {
    using StringUtils for string;

    // mapping(bytes32 => bytes) public proofs;
    mapping(string => bytes) public proofs;

    // mapping(address => bytes32[]) public myProofKeys;

    function validate(
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

    function validate(
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

    function validate(ProofOfAgreement memory _proof) internal view override returns (bool) {
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

    function save(
        ProofOfAuthorityShrinked memory _proof,
        string memory _proofCID
    ) internal override {
        // bytes32 key = keccak256(abi.encode(_proof.message));
        // proofs[_proofCID] = abi.encode(
        //     ProofOfAuthorityShrinked(_proof.sig, _proof.version, _proof.message)
        // );
        // myProofKeys[_proof.message.from].push(key);
        proofs[_proofCID] = abi.encode(
            ProofOfAuthorityShrinked(_proof.sig, _proof.version, _proof.message)
        );
        emit NewProofOfAuthority(_proof);
    }

    function save(ProofOfSignatureShrinked memory _proof) internal override {
        // bytes32 key = keccak256(abi.encode(_proof.message));
        // proofs[key] = abi.encode(
        //     ProofOfSignatureShrinked(_proof.sig, _proof.version, _proof.message)
        // );
        // myProofKeys[_proof.message.signer].push(key);
        emit NewProofOfSignature(_proof);
    }

    function save(ProofOfAgreement memory _proof) internal override {
        // bytes32 key = keccak256(abi.encode(_proof.message));
        // proofs[key] = abi.encode(
        //     ProofOfAgreement(_proof.sig, _proof.version, _proof.message)
        // );
        // myProofKeys[_proof.message.from].push(key);
        emit NewProofOfAgreement(_proof);
    }

    function getProofOfAuthority(
        string memory _proofCID
    ) public view override returns (ProofOfAuthorityShrinked memory) {
        return abi.decode(proofs[_proofCID], (ProofOfAuthorityShrinked));
    }

    // function myProofKeysLen(address _addr) public view returns (uint256) {
    //     return myProofKeys[_addr].length;
    // }

    // function get(
    //     ProofOfAuthorityMsg memory message
    // ) public view override returns (ProofOfAuthorityShrinked memory) {
    //     return abi.decode(proofs[keccak256(abi.encode(message))], (ProofOfAuthorityShrinked));
    // }

    // function getLastProofOfAuthority(
    //     address _addr
    // ) external view returns (ProofOfAuthorityShrinked memory _proof) {
    //     _proof = abi.decode(
    //         proofs[myProofKeys[_addr][myProofKeysLen(_addr) - 1]],
    //         (ProofOfAuthorityShrinked)
    //     );
    // }
}
