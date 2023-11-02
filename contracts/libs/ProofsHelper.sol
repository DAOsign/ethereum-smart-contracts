// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import { ProofTypes } from './common/ProofTypes.sol';
import { StringsExpanded } from './StringsExpanded.sol';
import { IProofsMetadata } from '../interfaces/IProofsMetadata.sol';

/**
 * ProofsHelper library helps Proofs smart contract to generate Proof-of-Authority, Proof-of-Signature, and
 * Proof-of-Agreement in a text format
 */
library ProofsHelper {
    using StringsExpanded for string;
    using StringsExpanded for bytes;
    using StringsExpanded for address;
    using StringsExpanded for uint256;

    /**
     * Returns full Proof-of-Authority or Proof-of-Signature (data with signature)
     * @param _creator Creator of the proof
     * @param _signature Signature of the proof data
     * @param _data Data that the user have signed
     * @return _proof The proof object as a string
     */
    function getProofOfAuthorityOrSignature(
        address _creator,
        bytes calldata _signature,
        string memory _data
    ) external pure returns (string memory _proof) {
        require(_creator != address(0), 'No creator');
        require(_signature.length > 0, 'No signature');
        require(_data.length() > 0, 'No data');
        _proof = string(
            abi.encodePacked(
                '{"address":"',
                _creator.toString(),
                '","sig":"',
                _signature.toHexString(),
                '","data":',
                _data,
                '}'
            )
        );
    }

    /**
     * Returns Proof-of-Authority data for the creator to sign
     * @param _proofsMetadata EIP712 part of the proof data defined in ProofsMetadata smart contract
     * @param _creator Creator of the agreement
     * @param _signers Signers of the agreement
     * @param _agreementFileCID IPFS CID of the agreement file
     * @param _version EIP712 version of the data
     * @param _timestamp Timestamp of the proof
     * @return data Proof-of-Authority data
     */
    function getProofOfAuthorityData(
        address _proofsMetadata,
        address _creator,
        address[] calldata _signers,
        string calldata _agreementFileCID,
        string calldata _version,
        uint256 _timestamp
    ) external view returns (string memory) {
        require(_creator != address(0), 'No creator');
        require(_signers.length > 0, 'No signers');
        require(_agreementFileCID.length() > 0, 'No Agreement File CID');
        require(_version.length() > 0, 'No version');

        return
            string(
                abi.encodePacked(
                    IProofsMetadata(_proofsMetadata).proofsMetadata(
                        ProofTypes.Proofs.ProofOfAuthority,
                        _version
                    ),
                    ',"message":',
                    getProofOfAuthorityDataMessage(
                        _creator,
                        _signers,
                        _agreementFileCID,
                        _timestamp
                    ),
                    '}'
                )
            );
    }

    /**
     * Returns Proof-of-Signature data for the signer to sign
     * @param _proofsMetadata EIP712 part of the proof data defined in ProofsMetadata smart contract
     * @param _signer Current signer of the agreement from the list of agreement signers
     * @param _proofOfAuthorityCID IPFS CID of the Proof-of-Authority
     * @param _version EIP712 version of the data
     * @param _timestamp Timestamp of the proof
     * @return data Proof-of-Signature data
     */
    function getProofOfSignatureData(
        address _proofsMetadata,
        address _signer,
        string calldata _proofOfAuthorityCID,
        string calldata _version,
        uint256 _timestamp
    ) external view returns (string memory) {
        require(_signer != address(0), 'No signer');
        require(_proofOfAuthorityCID.length() > 0, 'No Proof-of-Authority CID');
        require(_version.length() > 0, 'No version');

        return
            string(
                abi.encodePacked(
                    IProofsMetadata(_proofsMetadata).proofsMetadata(
                        ProofTypes.Proofs.ProofOfSignature,
                        _version
                    ),
                    ',"message":',
                    getProofOfSignatureDataMessage(_signer, _proofOfAuthorityCID, _timestamp),
                    '}'
                )
            );
    }

    /**
     * Returns Proof-of-Agreement data that is equal to Proof-of-Agreement as it requires no
     * signature
     * @param _proofOfAuthorityCID IPFS CID of the Proof-of-Authority
     * @param _proofsOfSignatureCID Array of IPFS CID of every Proof-of-Signature from the agreement
     * @param _timestamp Timestamp of the proof
     * @return data Proof-of-Agreement data
     */
    function getProofOfAgreementData(
        string calldata _proofOfAuthorityCID,
        string[] calldata _proofsOfSignatureCID,
        uint256 _timestamp
    ) external pure returns (string memory) {
        require(_proofOfAuthorityCID.length() > 0, 'No Proof-of-Authority CID');
        for (uint256 i = 0; i < _proofsOfSignatureCID.length; i++) {
            require(_proofsOfSignatureCID[i].length() > 0, 'No Proof-of-Signature CID');
        }

        string memory arrOfPoSigs = '{"proofCID":"';
        for (uint256 i = 0; i < _proofsOfSignatureCID.length; i++) {
            if (i != _proofsOfSignatureCID.length - 1) {
                arrOfPoSigs = string(
                    abi.encodePacked(arrOfPoSigs, _proofsOfSignatureCID[i], '"},{"proofCID":"')
                );
            } else {
                // the last proofCID
                arrOfPoSigs = string(
                    abi.encodePacked(arrOfPoSigs, _proofsOfSignatureCID[i], '"}]')
                );
            }
        }

        return
            string(
                abi.encodePacked(
                    '{"agreementFileProofCID":"',
                    _proofOfAuthorityCID,
                    '","agreementSignProofs":[',
                    arrOfPoSigs,
                    ',"timestamp":',
                    _timestamp.toString(),
                    '}'
                )
            );
    }

    /**
     * Returns the core message (without EIP712 metadata) of Proof-of-Authority for the creator to
     * sign
     * @param _creator Agreement creator address
     * @param _signers Array of signers of the agreement
     * @param _agreementFileCID IPFS CID of the agreement file
     * @return _message Proof-of-Authority message to sign
     */
    function getProofOfAuthorityDataMessage(
        address _creator,
        address[] calldata _signers,
        string calldata _agreementFileCID,
        uint256 _timestamp
    ) public pure returns (string memory _message) {
        _message = string(
            abi.encodePacked(
                '{"name":"Proof-of-Authority","from":"',
                _creator.toString(),
                '","agreementFileCID":"',
                _agreementFileCID,
                '","signers":',
                generateSignersJSON(_signers),
                ',"app":"daosign","timestamp":',
                _timestamp.toString(),
                ',"metadata":"{}"}'
            )
        );
    }

    /**
     * Returns the core message (without EIP712 metadata) of Proof-of-Signature for the signer to
     * sign
     * @param _signer Current signer of the agreement from the list of agreement signers
     * @param _proofOfAuthorityCID IPFS CID of the Proof-of-Authority
     * @param _timestamp Timestamp of the proof
     * @return _message Proof-of-Authority message to sign
     */
    function getProofOfSignatureDataMessage(
        address _signer,
        string calldata _proofOfAuthorityCID,
        uint256 _timestamp
    ) public pure returns (string memory _message) {
        _message = string(
            abi.encodePacked(
                '{"signer":"',
                _signer.toString(),
                '","agreementFileProofCID":"',
                _proofOfAuthorityCID,
                '","app":"daosign","timestamp":',
                _timestamp.toString(),
                ',"metadata":{}}'
            )
        );
    }

    /**
     * Generates a JSON stringified content with signers of the agreement
     * @param _signers Array of signers of the agreement
     * @return res JSON stringified list of signers
     */
    function generateSignersJSON(address[] calldata _signers) public pure returns (string memory) {
        string memory res = '[';

        for (uint256 i = 0; i < _signers.length; i++) {
            res = res.concat(
                string(abi.encodePacked('{"addr":"', _signers[i].toString(), '","metadata":"{}"}'))
            );
            if (i != _signers.length - 1) {
                res = res.concat(',');
            }
        }

        res = res.concat(']');

        return res;
    }
}
