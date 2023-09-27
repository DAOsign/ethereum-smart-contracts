// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

// import 'hardhat/console.sol';

import { IERC165 } from '@openzeppelin/contracts/utils/introspection/IERC165.sol';
import { ERC165Checker } from '@openzeppelin/contracts/utils/introspection/ERC165Checker.sol';
import { IProofsMetadata } from './interfaces/IProofsMetadata.sol';
import { StringsExpanded } from './libs/StringsExpanded.sol';
import { ProofsVerification } from './libs/ProofsVerification.sol';
import { ProofsHelper } from './libs/ProofsHelper.sol';
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

    address public proofsMetadata;

    // Agreement File CID -> Proof CID -> Proof Data
    mapping(string => mapping(string => string)) public finalProofs;

    // Agreement File CID -> Proof type -> singer address (or zero address for Proof-of-Agreement) -> Proof Data
    mapping(string => mapping(ProofTypes.Proofs => mapping(address => string))) public proofsData;

    event ProofOfAuthority(
        address indexed creator,
        bytes signature,
        string indexed agreementFileCID,
        string proofCID,
        string proofJSON
    );
    event ProofOfSignature(
        address indexed signer,
        bytes signature,
        string indexed agreementFileCID,
        string proofCID,
        string proofJSON
    );
    event ProofOfAgreement(
        string indexed agreementFileCID,
        string proofOfAuthorityCID,
        string proofCID,
        string proofJSON
    );

    // TODO: potentially add structs to store data from each proof to verify
    //       Proof-of-Signature and Proof-of-Agreement as they are dependant on other proofs

    constructor(address _proofsMetadata) {
        require(
            ERC165Checker.supportsERC165(_proofsMetadata) &&
                IERC165(_proofsMetadata).supportsInterface(type(IProofsMetadata).interfaceId),
            'Must support IProofsMetadata'
        );
        proofsMetadata = _proofsMetadata;
    }

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
        // TODO: require finalProofs[_agreementFileCID][_proofOfAuthorityCID] exists
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

    function fetchProofOfAgreementData(
        string calldata _agreementFileCID,
        string calldata _proofOfAuthorityCID,
        string[] calldata _proofsOfSignatureCID
    ) public returns (string memory) {
        require(_agreementFileCID.length() > 0, 'No Agreement File CID');
        if (
            // TODO: Fix: for the same agreement file there may not exist the same 2 Proofs-of-Agreement
            proofsData[_agreementFileCID][ProofTypes.Proofs.ProofOfAgreement][address(0)].length() >
            0
        ) {
            return proofsData[_agreementFileCID][ProofTypes.Proofs.ProofOfAgreement][address(0)];
        }
        // TODO: require finalProofs[_agreementFileCID][_proofOfAuthorityCID] exists
        // TODO: require finalProofs[_agreementFileCID][_proofsOfSignatureCID] exists
        string memory proofData = ProofsHelper.getProofOfAgreementData(
            _proofOfAuthorityCID,
            _proofsOfSignatureCID,
            block.timestamp
        );
        proofsData[_agreementFileCID][ProofTypes.Proofs.ProofOfAgreement][address(0)] = proofData;
        return proofData;
    }

    function storeProofOfAuthority(
        address _creator,
        bytes calldata _signature,
        string calldata _agreementFileCID,
        string calldata _proofCID
    ) public {
        require(_proofCID.length() > 0, 'No ProofCID');
        require(finalProofs[_agreementFileCID][_proofCID].length() == 0, 'Proof already stored');
        // TODO: get timestamp from the proof and update proofsData mapping: replace _creator with timestamp
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

    function storeProofOfAgreement(
        string calldata _agreementFileCID,
        string calldata _proofOfAuthorityCID, // TODO: involve this proofs into PoA storage to enable having multiple
        //       PoA for the same AgreementFileCID
        string calldata _proofOfAgreementCID
    ) public {
        require(_proofOfAgreementCID.length() > 0, 'No ProofCID');
        require(_agreementFileCID.length() > 0, 'No Agreement File CID');
        require(
            finalProofs[_agreementFileCID][_proofOfAgreementCID].length() == 0,
            'Proof already stored'
        );

        // TODO: Fix: for the same agreement file there may not exist the same 2 Proofs-of-Agreement
        finalProofs[_agreementFileCID][_proofOfAgreementCID] = proofsData[_agreementFileCID][
            ProofTypes.Proofs.ProofOfAgreement
        ][address(0)];

        emit ProofOfAgreement(
            _agreementFileCID,
            _proofOfAuthorityCID,
            _proofOfAgreementCID,
            finalProofs[_agreementFileCID][_proofOfAgreementCID]
        );
    }
}
