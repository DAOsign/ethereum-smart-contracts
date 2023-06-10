// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

// import "hardhat/console.sol";

import { StringsLib } from './libs/StringsLib.sol';
import { Ownable } from '@openzeppelin/contracts/access/Ownable.sol';

contract ProofsMetadata is Ownable {
    using StringsLib for string;

    event MetadataAdded(string indexed name, string indexed version, string metadata);
    event MetadataEdited(string indexed name, string indexed version, string metadata);

    // proof name -> version -> metadata itself
    mapping(string => mapping(string => string)) public proofsMetadata;
    // proof name -> history of versions
    mapping(string => string[]) public metadataVersions;

    function addMetadata(
        string memory name,
        string memory version,
        string memory metadata
    ) public onlyOwner {
        require(
            name.length() > 0 && version.length() > 0 && metadata.length() > 0,
            'Input params cannot be empty'
        );
        require(proofsMetadata[name][version].length() == 0, 'Metadata already exists; update it');

        proofsMetadata[name][version] = metadata;
        metadataVersions[name].push(version);

        emit MetadataAdded(name, version, metadata);
    }

    function updateMetadata(
        string memory name,
        string memory version,
        string memory metadata
    ) public onlyOwner {
        require(
            name.length() > 0 && version.length() > 0 && metadata.length() > 0,
            'Input params cannot be empty'
        );
        require(
            proofsMetadata[name][version].length() > 0,
            'Metadata does not exist; add it first'
        );

        proofsMetadata[name][version] = metadata;
        metadataVersions[name].push(version);

        emit MetadataEdited(name, version, metadata);
    }
}
