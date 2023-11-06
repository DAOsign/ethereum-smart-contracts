// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { ProofsBase } from './ProofsBase.sol';
import { StringUtils } from './lib/StringUtils.sol';

contract DAOsignProofs is ProofsBase {
    using StringUtils for string;

    function initializeDAOsignProofs(address _owner) public initializer {
        ProofsBase.initializeProofsBase(_owner);
    }

    function getProofOfAuthority(
        string memory _proofCID
    ) external view returns (ProofOfAuthorityShrinked memory) {
        return abi.decode(proofs[_proofCID], (ProofOfAuthorityShrinked));
    }

    function getProofOfSignature(
        string memory _proofCID
    ) external view returns (ProofOfSignatureShrinked memory) {
        return abi.decode(proofs[_proofCID], (ProofOfSignatureShrinked));
    }

    function getProofOfAgreement(
        string memory _proofCID
    ) external view returns (ProofOfAgreement memory) {
        return abi.decode(proofs[_proofCID], (ProofOfAgreement));
    }

    function storeProofOfAuthority(
        ProofOfAuthorityShrinked memory _proof,
        string memory _proofCID
    ) external {
        require(_proofCID.length() == 46, 'Invalid proof CID');
        require(recover(_proof.message, _proof.sig) == _proof.message.from, 'Invalid signature');
        require(_validate(_proof), 'Invalid input params');
        _store(_proof, _proofCID);
    }

    function storeProofOfSignature(
        ProofOfSignatureShrinked memory _proof,
        string memory _proofCID
    ) external {
        require(_proofCID.length() == 46, 'Invalid proof CID');
        require(recover(_proof.message, _proof.sig) == _proof.message.signer, 'Invalid signature');
        require(_validate(_proof), 'Invalid input params');
        _store(_proof, _proofCID);
    }

    // TODO: call this function automatically once the last Proof-of-Signature is generated
    function storeProofOfAgreement(
        ProofOfAgreement memory _proof,
        string memory _proofCID
    ) external {
        require(_proofCID.length() == 46, 'Invalid proof CID');
        require(_validate(_proof), 'Invalid input params');
        _store(_proof, _proofCID);
    }
}
