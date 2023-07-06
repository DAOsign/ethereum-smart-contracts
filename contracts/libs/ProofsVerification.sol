// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import { ECDSA } from '@openzeppelin/contracts/utils/cryptography/ECDSA.sol';

// import 'hardhat/console.sol';

/**
 * Verifies Proof-of-Authority and Proof-of-Signature validity. May be used to verify any Ethereum
 * signature.
 */
library ProofsVerification {
    using ECDSA for bytes32;

    /**
     * Verify Proof-of-Authority signature
     * @param _signer Signer of the data
     * @param _data Raw Proof-of-Authority stringified JSON object that the signer signs.
     *              Note: it may be the output of Proofs.getPoSiData function
     * @param _signature Signature of the {_data}
     * @return isValid Is signature valid or not
     */
    function verifyPoAu(
        address _signer,
        string memory _data,
        bytes calldata _signature
    ) public pure returns (bool) {
        bytes32 dataHash = keccak256(abi.encodePacked(abi.encodePacked(_data)));
        return verify(_signer, dataHash, _signature);
    }

    /**
     * Verify any Ethereum signature of any data
     * @param _signer Signer of the data
     * @param _dataHash Hash of the data that was signed
     * @param _signature Signature of the data
     * @return isValid Is signature valid or not
     */
    function verify(
        address _signer,
        bytes32 _dataHash,
        bytes calldata _signature
    ) public pure returns (bool) {
        return _dataHash.toEthSignedMessageHash().recover(_signature) == _signer;
    }
}
