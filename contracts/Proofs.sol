// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import { IERC165 } from '@openzeppelin/contracts/utils/introspection/IERC165.sol';
import { ERC165Checker } from '@openzeppelin/contracts/utils/introspection/ERC165Checker.sol';
import { IProofsMetadata } from './interfaces/IProofsMetadata.sol';
import { IProofs } from './interfaces/IProofs.sol';
import { StringsExpanded } from './libs/StringsExpanded.sol';
import { ProofsVerification } from './libs/ProofsVerification.sol';
import { ProofsHelper } from './libs/ProofsHelper.sol';
import { ProofTypes } from './libs/common/ProofTypes.sol';

/**
 * Stores DAOsign proofs.
 *
 * Note
 * Proof-of-Authority = PoA
 * Proof-of-Signature = PoS
 * Proof-of-Agreement = PoAg
 */
contract Proofs is IProofs {
    using StringsExpanded for string;

    address public proofsMetadata;

    // Agreement File CID -> Proof CID -> Proof Data
    mapping(string => mapping(string => string)) public finalProofs;

    // Agreement File CID -> Proof type -> singer address (or zero address for Proof-of-Agreement) -> Proof Data
    mapping(string => mapping(ProofTypes.Proofs => mapping(address => string))) public proofsData;

    constructor(address _proofsMetadata) {
        require(
            ERC165Checker.supportsERC165(_proofsMetadata) &&
                IERC165(_proofsMetadata).supportsInterface(type(IProofsMetadata).interfaceId),
            'Must support IProofsMetadata'
        );
        proofsMetadata = _proofsMetadata;
    }

    /**
     * Generates Proof-of-Authority data for creator to sign and caches it in the smart contract
     * memory
     * @param _creator Agreement creator address
     * @param _signers Array of signers of the agreement
     * @param _agreementFileCID IPFS CID of the agreement file
     * @param _version EIP712 version of the data
     * @return proofData Proof-of-Authority data to sign
     */
    function fetchProofOfAuthorityData(
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
        string memory proofData = ProofsHelper.getProofOfAuthorityData(
            proofsMetadata,
            _creator,
            _signers,
            _agreementFileCID,
            _version,
            block.timestamp
        );
        proofsData[_agreementFileCID][ProofTypes.Proofs.ProofOfAuthority][_creator] = proofData;
        return proofData;
    }

    /**
     * Generates Proof-of-Signature data for creator to sign and caches it in the smart contract
     * memory
     * @param _signer Current signer of the agreement from the list of agreement signers
     * @param _agreementFileCID IPFS CID of the agreement file
     * @param _proofOfAuthorityCID IPFS CID of Proof-of-Authority
     * @param _version EIP712 version of the data
     * @return proofData Proof-of-Signature data to sign
     */
    function fetchProofOfSignatureData(
        address _signer,
        string calldata _agreementFileCID,
        string calldata _proofOfAuthorityCID,
        string calldata _version
    ) public returns (string memory) {
        require(_agreementFileCID.length() > 0, 'No Agreement File CID');
        if (
            proofsData[_agreementFileCID][ProofTypes.Proofs.ProofOfSignature][_signer].length() > 0
        ) {
            return proofsData[_agreementFileCID][ProofTypes.Proofs.ProofOfSignature][_signer];
        }
        require(
            finalProofs[_agreementFileCID][_proofOfAuthorityCID].length() > 0,
            'No Proof-of-Authority'
        );

        string memory proofData = ProofsHelper.getProofOfSignatureData(
            proofsMetadata,
            _signer,
            _proofOfAuthorityCID,
            _version,
            block.timestamp
        );
        proofsData[_agreementFileCID][ProofTypes.Proofs.ProofOfSignature][_signer] = proofData;
        return proofData;
    }

    /**
     * Generates Proof-of-Agreement data for creator to sign and caches it in the smart contract
     * memory
     * @param _agreementFileCID IPFS CID of the agreement file
     * @param _proofOfAuthorityCID IPFS CID of Proof-of-Authority
     * @param _proofsOfSignatureCID IPFS CID of Proof-of-Signature
     * @return proofData Proof-of-Agreement data to sign
     */
    function fetchProofOfAgreementData(
        string calldata _agreementFileCID,
        string calldata _proofOfAuthorityCID,
        string[] calldata _proofsOfSignatureCID
    ) public returns (string memory) {
        require(_agreementFileCID.length() > 0, 'No Agreement File CID');
        if (
            // Note: The same agreement file can be used for 2 or more agreements only if done sequentially.
            //       While there is one agreement proof waiting to be added to IPFS, another agreement with the same
            //       agreement file will override the `proofsData` mapping for this agreement
            proofsData[_agreementFileCID][ProofTypes.Proofs.ProofOfAgreement][address(0)].length() >
            0
        ) {
            return proofsData[_agreementFileCID][ProofTypes.Proofs.ProofOfAgreement][address(0)];
        }
        require(
            finalProofs[_agreementFileCID][_proofOfAuthorityCID].length() > 0,
            'No Proof-of-Authority'
        );
        for (uint256 i = 0; i < _proofsOfSignatureCID.length; i++) {
            require(
                finalProofs[_agreementFileCID][_proofsOfSignatureCID[i]].length() > 0,
                'No Proof-of-Signature'
            );
        }
        string memory proofData = ProofsHelper.getProofOfAgreementData(
            _proofOfAuthorityCID,
            _proofsOfSignatureCID,
            block.timestamp
        );
        proofsData[_agreementFileCID][ProofTypes.Proofs.ProofOfAgreement][address(0)] = proofData;
        return proofData;
    }

    /**
     * Stores Proof-of-Authority after verifying the correctness of the signature
     * @param _creator Agreement creator address
     * @param _signature Signature of Proof-of-Authority data
     * @param _agreementFileCID IPFS CID of the agreement file
     * @param _proofCID IPFS CID of Proof-of-Authority
     */
    function storeProofOfAuthority(
        address _creator,
        bytes calldata _signature,
        string calldata _agreementFileCID,
        string calldata _proofCID
    ) public {
        require(_proofCID.length() > 0, 'No ProofCID');
        require(finalProofs[_agreementFileCID][_proofCID].length() == 0, 'Proof already stored');
        require(
            ProofsVerification.verifySignedProof(
                _creator,
                proofsData[_agreementFileCID][ProofTypes.Proofs.ProofOfAuthority][_creator],
                _signature
            ),
            'Invalid signature'
        );

        string memory proof = ProofsHelper.getProofOfAuthorityOrSignature(
            _creator,
            _signature,
            proofsData[_agreementFileCID][ProofTypes.Proofs.ProofOfAuthority][_creator]
        );
        finalProofs[_agreementFileCID][_proofCID] = proof;

        emit ProofOfAuthority(_creator, _signature, _agreementFileCID, _proofCID, proof);
    }

    /**
     * Stores Proof-of-Signature after verifying the correctness of the signature
     * @param _signer Current signer of the agreement from the list of agreement signers
     * @param _signature Signature of Proof-of-Signature data
     * @param _agreementFileCID IPFS CID of the agreement file
     * @param _proofCID IPFS CID of Proof-of-Signature
     */
    function storeProofOfSignature(
        address _signer,
        bytes calldata _signature,
        string calldata _agreementFileCID,
        string calldata _proofCID
    ) public {
        require(_proofCID.length() > 0, 'No ProofCID');
        require(finalProofs[_agreementFileCID][_proofCID].length() == 0, 'Proof already stored');
        require(
            ProofsVerification.verifySignedProof(
                _signer,
                proofsData[_agreementFileCID][ProofTypes.Proofs.ProofOfSignature][_signer],
                _signature
            ),
            'Invalid signature'
        );

        string memory proof = ProofsHelper.getProofOfAuthorityOrSignature(
            _signer,
            _signature,
            proofsData[_agreementFileCID][ProofTypes.Proofs.ProofOfSignature][_signer]
        );
        finalProofs[_agreementFileCID][_proofCID] = proof;

        emit ProofOfSignature(_signer, _signature, _agreementFileCID, _proofCID, proof);
    }

    /**
     * Stores Proof-of-Agreement
     * @param _agreementFileCID IPFS CID of the agreement file
     * @param _proofOfAuthorityCID IPFS CID of Proof-of-Authority
     * @param _proofCID IPFS CID of Proof-of-Agreement
     */
    function storeProofOfAgreement(
        string calldata _agreementFileCID,
        string calldata _proofOfAuthorityCID,
        string calldata _proofCID
    ) public {
        require(_proofCID.length() > 0, 'No ProofCID');
        require(_agreementFileCID.length() > 0, 'No Agreement File CID');
        require(finalProofs[_agreementFileCID][_proofCID].length() == 0, 'Proof already stored');
        require(
            finalProofs[_agreementFileCID][_proofOfAuthorityCID].length() > 0,
            'Invalid input data'
        );

        finalProofs[_agreementFileCID][_proofCID] = proofsData[_agreementFileCID][
            ProofTypes.Proofs.ProofOfAgreement
        ][address(0)];

        emit ProofOfAgreement(
            _agreementFileCID,
            _proofOfAuthorityCID,
            _proofCID,
            finalProofs[_agreementFileCID][_proofCID]
        );
    }
}
