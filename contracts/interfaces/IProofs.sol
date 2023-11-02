// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import { ProofTypes } from '../libs/common/ProofTypes.sol';

interface IProofs {
    event ProofOfAuthorityEvent(
        address indexed creator,
        bytes signature,
        string indexed agreementFileCID,
        string proofCID,
        string proofJSON
    );
    event ProofOfSignatureEvent(
        address indexed signer,
        bytes signature,
        string indexed agreementFileCID,
        string proofCID,
        string proofJSON
    );
    event ProofOfAgreementEvent(
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

    function poaData(bytes32 input) external view returns (string memory);

    function posData(bytes32 input) external view returns (string memory);

    function poagData(bytes32 input) external view returns (string memory);

    /**
     * Actual functions
     */
    // function fetchProofOfAuthorityData(
    //     address _creator,
    //     address[] calldata _signers,
    //     string calldata _agreementFileCID,
    //     string calldata _version,
    //     bytes calldata _dataSig
    // ) external returns (string memory);

    // function fetchProofOfSignatureData(
    //     address _signer,
    //     string calldata _agreementFileCID,
    //     string calldata _proofOfAuthorityCID,
    //     string calldata _version,
    //     bytes calldata _dataSig
    // ) external returns (string memory);

    // function fetchProofOfAgreementData(
    //     string calldata _agreementFileCID,
    //     string calldata _proofOfAuthorityCID,
    //     string[] calldata _proofsOfSignatureCID
    // ) external returns (string memory);

    function storeProofOfAuthority(
        address _creator,
        address[] calldata _signers,
        string calldata _version,
        bytes calldata _signature,
        string calldata _fileCID,
        string calldata _proofCID
    ) external;

    function storeProofOfSignature(
        address _signer,
        bytes calldata _signature,
        string calldata _fileCID,
        string calldata _posCID,
        string calldata _poaCID,
        string calldata _version
    ) external;

    function storeProofOfAgreement(
        string calldata _fileCID,
        string calldata _poaCID,
        string[] calldata _posCIDs,
        string calldata _poagCID
    ) external;

    function getPoAData(
        address _creator,
        address[] calldata _signers,
        string calldata _fileCID,
        string calldata _version
    ) external view returns (string memory);

    function getPoSData(
        address _signer,
        string calldata _fileCID,
        string calldata _poaCID,
        string calldata _version
    ) external view returns (string memory);

    function getPoAgData(
        string calldata _fileCID,
        string calldata _poaCID,
        string[] calldata _posCIDs
    ) external view returns (string memory);
}
