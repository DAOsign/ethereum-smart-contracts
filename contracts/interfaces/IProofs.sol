// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import { ProofTypes } from '../libs/common/ProofTypes.sol';

interface IProofs {
    event NewProofOfAuthority(ProofOfAuthorityMsg indexed message);
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

    struct EIP712Domain {
        string name;
        string version;
    }
    struct Signer {
        address addr;
        string metadata;
    }
    struct ProofOfAuthorityMsg {
        string name;
        address from;
        string agreementFileCID;
        Signer[] signers;
        string app;
        uint64 timestamp;
        string metadata;
    }
    struct ProofOfAuthorityShrinked {
        bytes sig;
        string version;
        ProofOfAuthorityMsg message;
    }

    /**
     * Functions from variables
     */
    // function proofsMetadata() external view returns (address);

    // function finalProofs(
    //     string calldata agreementFileCID,
    //     string calldata proofCID
    // ) external view returns (string memory);

    // function poaData(bytes32 input) external view returns (string memory);

    // function posData(bytes32 input) external view returns (string memory);

    // function poagData(bytes32 input) external view returns (string memory);

    // function storeProofOfAuthority(
    //     address _creator,
    //     address[] calldata _signers,
    //     string calldata _version,
    //     bytes calldata _signature,
    //     string calldata _fileCID,
    //     string calldata _proofCID
    // ) external;

    // function storeProofOfSignature(
    //     address _signer,
    //     bytes calldata _signature,
    //     string calldata _fileCID,
    //     string calldata _posCID,
    //     string calldata _poaCID,
    //     string calldata _version
    // ) external;

    // function storeProofOfAgreement(
    //     string calldata _fileCID,
    //     string calldata _poaCID,
    //     string[] calldata _posCIDs,
    //     string calldata _poagCID
    // ) external;
}
