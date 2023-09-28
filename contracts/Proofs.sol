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
        // uint256 time = block.timestamp;
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
