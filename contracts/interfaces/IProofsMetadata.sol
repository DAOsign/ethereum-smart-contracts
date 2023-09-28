// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import { ProofTypes } from '../libs/common/ProofTypes.sol';

interface IProofsMetadata {
    event MetadataAdded(ProofTypes.Proofs proof, string indexed version, bytes metadata);
    event MetadataUpdated(ProofTypes.Proofs proof, string indexed version, bytes metadata);

    function proofsMetadata(
        ProofTypes.Proofs _type,
        string calldata _version
    ) external view returns (bytes memory);

    function metadataVersions(
        ProofTypes.Proofs _type,
        uint256 index
    ) external view returns (string memory);

    function getMetadataNumOfVersions(ProofTypes.Proofs _type) external view returns (uint256);

    function addMetadata(
        ProofTypes.Proofs _type,
        string calldata _version,
        bytes calldata _metadata
    ) external;

    function forceUpdateMetadata(
        ProofTypes.Proofs _type,
        string calldata _version,
        bytes calldata _metadata
    ) external;
}
