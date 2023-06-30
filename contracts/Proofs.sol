// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

// import 'hardhat/console.sol';

import { IERC165 } from '@openzeppelin/contracts/utils/introspection/IERC165.sol';
import { ERC165Checker } from '@openzeppelin/contracts/utils/introspection/ERC165Checker.sol';
import { IProofsMetadata } from './interfaces/IProofsMetadata.sol';
import { Strings } from './libs/Strings.sol';

/**
 * Stores DAOsign proofs.
 */
contract Proofs {
    using Strings for string;
    using Strings for uint256;
    using Strings for address;

    address public proofsMetadata;
    address public proofsVerificationLib;

    // Agreement File CID -> Proof type -> Proof CID
    mapping(string => mapping(string => string)) public signedProofs;
    // Agreement File CID -> Proof type -> Proof Data
    mapping(string => mapping(string => string)) public proofsData;

    constructor(address _proofsMetadata, address _proofsVerificationLib) {
        require(
            ERC165Checker.supportsERC165(_proofsMetadata) &&
                IERC165(_proofsMetadata).supportsInterface(type(IProofsMetadata).interfaceId),
            'Must support IProofsMetadata'
        );
        proofsMetadata = _proofsMetadata;
        proofsVerificationLib = _proofsVerificationLib;
    }

    /**
    Public:
    - Create Proof-of-Authority data (given a creator's address, agreementFileCID, and the list of signers)
    - Create Proof-of-Signature (given a signer's address and Proof-of-Authority IPFS CID)
    - Sign (off-chain), store & verify signature of the data (used for any proof), generate proof IPFS CID

    System:
    - autogenereate Proof-of-Agreement
     */

    function getProofOfAuthorityData(
        address _creator,
        address[] calldata _signers,
        string calldata _agreementFileCID,
        string calldata _version
    ) public view returns (string memory) {
        require(_creator != address(0), 'No creator');
        require(_signers.length > 0, 'No signers');
        require(_agreementFileCID.length() > 0, 'No Agreement File CID');
        require(_version.length() > 0, 'No version');

        return
            string(
                abi.encodePacked(
                    IProofsMetadata(proofsMetadata).proofsMetadata('Proof-of-Authority', _version),
                    ',"message":',
                    _getProofOfAuthorityDataMessage(_creator, _signers, _agreementFileCID),
                    '}'
                )
            );
    }

    function getProofOfSignatureData(
        address _signer,
        string calldata _proofOfAuthorityCID,
        string calldata _version
    ) public view returns (string memory) {
        require(_signer != address(0), 'No signer');
        require(_proofOfAuthorityCID.length() > 0, 'No Proof-of-Authority CID');
        require(_version.length() > 0, 'No version');

        return
            string(
                abi.encodePacked(
                    IProofsMetadata(proofsMetadata).proofsMetadata('Proof-of-Signature', _version),
                    ',"message":',
                    _getProofOfSignatureDataMessage(_signer, _proofOfAuthorityCID),
                    '}'
                )
            );
    }

    function storeProofOfAuthority(
        string calldata _signature,
        address _creator,
        address[] calldata _signers,
        string calldata _agreementFileCID,
        string calldata _version
    ) public {
        /**
        {
            "address": "<User's address>",
            "sig": "<User's signature of Agreement File Proof Data>",
            "data": <Agreement File Proof Data object>
        }
         */
    }

    function _getProofOfAuthorityDataMessage(
        address _creator,
        address[] calldata _signers,
        string calldata _agreementFileCID
    ) internal view returns (string memory) {
        string memory message = string(
            abi.encodePacked(
                '{"from":"',
                _creator.toString(),
                '","agreementFileCID":"',
                _agreementFileCID,
                '","signers":',
                _generateSignersJSON(_signers),
                ',"app":"daosign","timestamp":',
                block.timestamp.toString(),
                ',"metadata":{}}'
            )
        );

        return message;
    }

    function _getProofOfSignatureDataMessage(
        address _signer,
        string calldata _proofOfAuthorityCID
    ) internal view returns (string memory) {
        string memory message = string(
            abi.encodePacked(
                '{"signer":"',
                _signer.toString(),
                '","agreementFileProofCID":"',
                _proofOfAuthorityCID,
                '","app":"daosign","timestamp":',
                block.timestamp.toString(),
                ',"metadata":{}}'
            )
        );

        return message;
    }

    function _generateSignersJSON(
        address[] calldata _signers
    ) internal pure returns (string memory) {
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
