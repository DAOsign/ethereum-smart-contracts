// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

// import "hardhat/console.sol";

import { Ownable } from '@openzeppelin/contracts/access/Ownable.sol';
import { ERC165 } from '@openzeppelin/contracts/utils/introspection/ERC165.sol';
import { StringsExpanded } from './libs/StringsExpanded.sol';
import { ProofTypes } from './libs/common/ProofTypes.sol';
import { IProofsMetadata } from './interfaces/IProofsMetadata.sol';

/**
 * Stores metadata for Proof-of-Authority, Proof-of-Signature, Proof-of-Agreement. Has an owner who
 * can update this metadata.
 */
contract ProofsMetadata is IProofsMetadata, Ownable, ERC165 {
    using StringsExpanded for string;

    // proof type -> version -> metadata itself
    mapping(ProofTypes.Proofs => mapping(string => string)) public proofsMetadata;
    // proof type -> history of versions
    mapping(ProofTypes.Proofs => string[]) public metadataVersions;

    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(ERC165) returns (bool) {
        return
            interfaceId == type(IProofsMetadata).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    /**
     * Get number of versions that exist for metadata by its name
     * @param _type Type of the proof metadata. Declared in {ProofTypes} library
     * @return numVersions Number of versions.
     */
    function getMetadataNumOfVersions(ProofTypes.Proofs _type) public view returns (uint256) {
        return metadataVersions[_type].length;
    }

    /**
     * Add metadata by the contract administrator.
     * @param _type Type of the proof metadata. Declared in {ProofTypes} library
     * @param _version Protocol version of the metadata. The version should be increased every time
     *                there is a change in the metadata.
     * @param _metadata Metadata in JSON format.
     */
    function addMetadata(
        ProofTypes.Proofs _type,
        string calldata _version,
        string calldata _metadata
    ) public onlyOwner {
        require(_version.length() > 0 && _metadata.length() > 0, 'Input params cannot be empty');
        require(proofsMetadata[_type][_version].length() == 0, 'Metadata already exists');

        proofsMetadata[_type][_version] = _metadata;
        metadataVersions[_type].push(_version);

        emit MetadataAdded(_type, _version, _metadata);
    }

    /**
     * Update metadata by the contract administrator.
     * Note: This has to be done ONLY in the event of incorrect data entry in `addMetadata`
     *       function. Update of metadata on the protocol level should be done by adding another
     *       metadata with newer version.
     * @param _type Type of the proof metadata. Declared in {ProofTypes} library
     * @param _version Protocol version of the metadata. The version should be increased every time
     *                there is a change in the metadata. This function is only to adjusting the
     *                inconsistency of metadata in smart contract and the one, used on the website.
     * @param _metadata Metadata in JSON format.
     */
    function forceUpdateMetadata(
        ProofTypes.Proofs _type,
        string calldata _version,
        string calldata _metadata
    ) public onlyOwner {
        require(_version.length() > 0 && _metadata.length() > 0, 'Input params cannot be empty');
        require(proofsMetadata[_type][_version].length() > 0, 'Metadata does not exist');

        proofsMetadata[_type][_version] = _metadata;

        emit MetadataUpdated(_type, _version, _metadata);
    }
}
