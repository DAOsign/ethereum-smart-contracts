// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import { ProofTypes } from '../libs/common/ProofTypes.sol';

interface IProofs {
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

    /**
     * Functions from variables
     */
    function proofsMetadata() external view returns (address);

    function finalProofs(
        string calldata agreementFileCID,
        string calldata proofCID
    ) external view returns (string memory);

    function proofsData(
        string calldata agreementFileCID,
        ProofTypes.Proofs proofType,
        address signer
    ) external view returns (string memory);

    /**
     * Actual functions
     */
    function fetchProofOfAuthorityData(
        address _creator,
        address[] calldata _signers,
        string calldata _agreementFileCID,
        string calldata _version
    ) external returns (string memory);

    function fetchProofOfSignatureData(
        address _signer,
        string calldata _agreementFileCID,
        string calldata _proofOfAuthorityCID,
        string calldata _version
    ) external returns (string memory);

    function fetchProofOfAgreementData(
        string calldata _agreementFileCID,
        string calldata _proofOfAuthorityCID,
        string[] calldata _proofsOfSignatureCID
    ) external returns (string memory);

    function storeProofOfAuthority(
        address _creator,
        bytes calldata _signature,
        string calldata _agreementFileCID,
        string calldata _proofCID
    ) external;

    function storeProofOfSignature(
        address _signer,
        bytes calldata _signature,
        string calldata _agreementFileCID,
        string calldata _proofCID
    ) external;

    function storeProofOfAgreement(
        string calldata _agreementFileCID,
        string calldata _proofOfAuthorityCID,
        string calldata _proofCID
    ) external;
}
