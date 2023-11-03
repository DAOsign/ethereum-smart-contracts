// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { Proofs } from './Proofs.sol';
import { StringUtils } from './lib/StringUtils.sol';

// TODO: make upgradeable
contract DAOsignProofs is Proofs {
    using StringUtils for string;

    mapping(bytes32 => bytes) public proofs;
    mapping(address => bytes32[]) public myProofKeys;

    function validate(ProofOfAuthorityShrinked memory _data) internal view override returns (bool) {
        require(_data.version.length() > 0, 'Invalid version');
        require(_data.message.name.equal('Proof-of-Authority'), 'Invalid name');
        require(_data.message.agreementFileCID.length() == 46, 'Invalid CID length');
        require(_data.message.app.equal('daosign'), 'Invalid app');
        require(
            _data.message.timestamp <= block.timestamp &&
                _data.message.timestamp >= block.timestamp - 3 hours,
            'Invalid timestamp'
        );

        for (uint256 i = 0; i < _data.message.signers.length; i++) {
            require(_data.message.signers[i].addr != address(0), 'Invalid signer');
        }

        return true;
    }

    function validate(ProofOfSignatureShrinked memory _data) internal view override returns (bool) {
        require(_data.version.length() > 0, 'Invalid version');
        require(_data.message.name.equal('Proof-of-Signature'), 'Invalid name');
        require(_data.message.agreementFileProofCID.length() == 46, 'Invalid CID length');
        require(_data.message.app.equal('daosign'), 'Invalid app');
        require(
            _data.message.timestamp <= block.timestamp &&
                _data.message.timestamp >= block.timestamp - 3 hours,
            'Invalid timestamp'
        );

        return true;
    }

    function validate(ProofOfAgreementShrinked memory) internal pure override returns (bool) {
        return true;
    }

    function save(ProofOfAuthorityShrinked memory _proof) public override {
        bytes32 key = keccak256(abi.encode(_proof.message));
        proofs[key] = abi.encode(
            ProofOfAuthorityShrinked(_proof.sig, _proof.version, _proof.message)
        );
        myProofKeys[_proof.message.from].push(key);
        // emit NewProofOfAuthority((message));
    }

    function save(ProofOfSignatureShrinked memory message) public override {
        proofs[keccak256(abi.encode(message))] = abi.encode(message);
    }

    function save(ProofOfAgreementShrinked memory message) public override {
        proofs[keccak256(abi.encode(message))] = abi.encode(message);
    }

    function myProofKeysLen(address _addr) public view returns (uint256) {
        return myProofKeys[_addr].length;
    }

    function get(
        ProofOfAuthorityMsg memory message
    ) public view override returns (ProofOfAuthorityShrinked memory) {
        return abi.decode(proofs[keccak256(abi.encode(message))], (ProofOfAuthorityShrinked));
    }

    function getLastProofOfAuthority(
        address _addr
    ) external view returns (ProofOfAuthorityShrinked memory _proof) {
        _proof = abi.decode(
            proofs[myProofKeys[_addr][myProofKeysLen(_addr) - 1]],
            (ProofOfAuthorityShrinked)
        );
    }
}
