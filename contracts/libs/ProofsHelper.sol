// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import { ProofTypes } from './common/ProofTypes.sol';
import { StringsExpanded } from './StringsExpanded.sol';
import { IProofsMetadata } from '../interfaces/IProofsMetadata.sol';

library ProofsHelper {
    using StringsExpanded for string;
    using StringsExpanded for bytes;
    using StringsExpanded for address;
    using StringsExpanded for uint256;

    /**
     * Get full Proof-of-Authority or Proof-of-Signature
     */
    function getProofOfAuthorityOrSignature(
        address _creator,
        bytes calldata _signature,
        string memory _data
    ) external pure returns (string memory proof) {
        require(_creator != address(0), 'No creator');
        require(_signature.length > 0, 'No signature');
        require(_data.length() > 0, 'No data');
        proof = string(
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

    function getProofOfAuthorityDataMessage(
        address _creator,
        address[] calldata _signers,
        string calldata _agreementFileCID,
        uint256 _timestamp
    ) public pure returns (string memory message) {
        message = string(
            abi.encodePacked(
                '{"from":"',
                _creator.toString(),
                '","agreementFileCID":"',
                _agreementFileCID,
                '","signers":',
                generateSignersJSON(_signers),
                ',"app":"daosign","timestamp":',
                _timestamp.toString(),
                ',"metadata":{}}'
            )
        );
    }

    function getProofOfSignatureDataMessage(
        address _signer,
        string calldata _proofOfAuthorityCID,
        uint256 _timestamp
    ) public pure returns (string memory message) {
        message = string(
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

    function generateSignersJSON(address[] calldata _signers) public pure returns (string memory) {
        string memory res = '[';

        for (uint256 i = 0; i < _signers.length; i++) {
            res = res.concat(
                string(abi.encodePacked('{"address":"', _signers[i].toString(), '","metadata":{}}'))
            );
            if (i != _signers.length - 1) {
                res = res.concat(',');
            }
        }

        res = res.concat(']');

        return res;
    }
}
