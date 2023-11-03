// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { Proofs } from './Proofs.sol';
import { StringUtils } from './lib/StringUtils.sol';

contract DAOsignProofs is Proofs {
    using StringUtils for string;

    mapping(bytes32 => bytes) public data;

    function validate(ProofOfAuthorityShrinked memory _data) internal view override returns (bool) {
        require(_data.version.length() > 0, 'Invalid version');
        require(_data.message.name.equal('Proof-of-Authority'), 'Invalid name');
        // require(message.from == signer, 'Invalid from address');
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
