// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

interface IProofsMetadata {
    event MetadataAdded(string indexed name, string indexed version, string metadata);
    event MetadataUpdated(string indexed name, string indexed version, string metadata);

    function proofsMetadata(
        string calldata name,
        string calldata version
    ) external view returns (string memory);

    function metadataVersions(
        string calldata name,
        uint256 index
    ) external view returns (string memory);

    function getMetadataNumOfVersions(string memory name) external view returns (uint256);

    function addMetadata(
        string calldata name,
        string calldata version,
        string calldata metadata
    ) external;

    function forceUpdateMetadata(
        string calldata name,
        string calldata version,
        string calldata metadata
    ) external;
}
