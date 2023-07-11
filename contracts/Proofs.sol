// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

// import 'hardhat/console.sol';

import { IERC165 } from '@openzeppelin/contracts/utils/introspection/IERC165.sol';
import { ERC165Checker } from '@openzeppelin/contracts/utils/introspection/ERC165Checker.sol';
import { IProofsMetadata } from './interfaces/IProofsMetadata.sol';
import { StringsExpanded } from './libs/StringsExpanded.sol';
import { ProofsVerification } from './libs/ProofsVerification.sol';
import { ProofTypes } from './libs/common/ProofTypes.sol';

/**
 * Stores DAOsign proofs.
 *
 * Note
 * Proof-of-Authority = PoAu
 * Proof-of-Signature = PoSi
 * Proof-of-Agreement = PoAg
 */
contract Proofs {
    using StringsExpanded for string;
    using StringsExpanded for bytes;
    using StringsExpanded for uint256;
    using StringsExpanded for address;

    address public proofsMetadata;

    // Agreement File CID -> Proof CID -> Proof Data
    mapping(string => mapping(string => string)) public signedProofs;

    // Agreement File CID -> Proof type -> singer address -> Proof Data
    mapping(string => mapping(ProofTypes.Proofs => mapping(address => string))) public proofsData;

    event ProofOfAuthority(string indexed agreementFileCID, string proofCID, string proof);

    constructor(address _proofsMetadata) {
        require(
            ERC165Checker.supportsERC165(_proofsMetadata) &&
                IERC165(_proofsMetadata).supportsInterface(type(IProofsMetadata).interfaceId),
            'Must support IProofsMetadata'
        );
        proofsMetadata = _proofsMetadata;
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
    ) public returns (string memory) {
        if (
            proofsData[_agreementFileCID][ProofTypes.Proofs.ProofOfAuthority][_creator].length() > 0
        ) {
            return proofsData[_agreementFileCID][ProofTypes.Proofs.ProofOfAuthority][_creator];
        }
        string memory proofData = _getProofOfAuthorityData(
            _creator,
            _signers,
            _agreementFileCID,
            _version,
            block.timestamp
        );
        proofsData[_agreementFileCID][ProofTypes.Proofs.ProofOfAuthority][_creator] = proofData;
        return proofData;
    }

    function getProofOfSignatureData(
        address _signer,
        string calldata _proofOfAuthorityCID,
        string calldata _version
    ) public view returns (string memory) {
        return _getProofOfSignatureData(_signer, _proofOfAuthorityCID, _version, block.timestamp);
    }

    function storeProofOfAuthority(
        address _creator,
        bytes calldata _signature,
        string calldata _agreementFileCID,
        string calldata _proofCID
    ) public {
        require(_proofCID.length() > 0, 'Empty ProofCID');
        require(signedProofs[_agreementFileCID][_proofCID].length() == 0, 'Proof already stored');
        require(
            ProofsVerification.verifyProofOfAuthority(
                _creator,
                proofsData[_agreementFileCID][ProofTypes.Proofs.ProofOfAuthority][_creator],
                _signature
            ),
            'Invalid signature'
        );

        string memory proof = _getProofOfAuthority(
            _creator,
            _signature,
            proofsData[_agreementFileCID][ProofTypes.Proofs.ProofOfAuthority][_creator]
        );
        signedProofs[_agreementFileCID][_proofCID] = proof;

        emit ProofOfAuthority(_agreementFileCID, _proofCID, proof);
    }

    function _getProofOfAuthority(
        address _creator,
        bytes calldata _signature,
        string memory _data
    ) internal pure returns (string memory proof) {
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

    function _getProofOfAuthorityData(
        address _creator,
        address[] calldata _signers,
        string calldata _agreementFileCID,
        string calldata _version,
        uint256 _timestamp
    ) internal view returns (string memory) {
        require(_creator != address(0), 'No creator');
        require(_signers.length > 0, 'No signers');
        require(_agreementFileCID.length() > 0, 'No Agreement File CID');
        require(_version.length() > 0, 'No version');

        return
            string(
                abi.encodePacked(
                    IProofsMetadata(proofsMetadata).proofsMetadata(
                        ProofTypes.Proofs.ProofOfAuthority,
                        _version
                    ),
                    ',"message":',
                    _getProofOfAuthorityDataMessage(
                        _creator,
                        _signers,
                        _agreementFileCID,
                        _timestamp
                    ),
                    '}'
                )
            );
    }

    function _getProofOfSignatureData(
        address _signer,
        string calldata _proofOfAuthorityCID,
        string calldata _version,
        uint256 _timestamp
    ) internal view returns (string memory) {
        require(_signer != address(0), 'No signer');
        require(_proofOfAuthorityCID.length() > 0, 'No Proof-of-Authority CID');
        require(_version.length() > 0, 'No version');

        return
            string(
                abi.encodePacked(
                    IProofsMetadata(proofsMetadata).proofsMetadata(
                        ProofTypes.Proofs.ProofOfSignature,
                        _version
                    ),
                    ',"message":',
                    _getProofOfSignatureDataMessage(_signer, _proofOfAuthorityCID, _timestamp),
                    '}'
                )
            );
    }

    function _getProofOfAuthorityDataMessage(
        address _creator,
        address[] calldata _signers,
        string calldata _agreementFileCID,
        uint256 _timestamp
    ) internal pure returns (string memory message) {
        message = string(
            abi.encodePacked(
                '{"from":"',
                _creator.toString(),
                '","agreementFileCID":"',
                _agreementFileCID,
                '","signers":',
                _generateSignersJSON(_signers),
                ',"app":"daosign","timestamp":',
                _timestamp.toString(),
                ',"metadata":{}}'
            )
        );
    }

    function _getProofOfSignatureDataMessage(
        address _signer,
        string calldata _proofOfAuthorityCID,
        uint256 _timestamp
    ) internal pure returns (string memory message) {
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
