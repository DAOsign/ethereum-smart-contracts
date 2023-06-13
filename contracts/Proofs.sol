// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

// import "hardhat/console.sol";

import { IERC165 } from '@openzeppelin/contracts/utils/introspection/IERC165.sol';
import { ERC165Checker } from '@openzeppelin/contracts/utils/introspection/ERC165Checker.sol';
import { IProofsMetadata } from './interfaces/IProofsMetadata.sol';

/**
 * Stores DAOsign proofs.
 */
contract Proofs {
    address public proofsMetadata;

    constructor(address _proofsMetadata) {
        require(
            ERC165Checker.supportsERC165(_proofsMetadata) &&
                IERC165(_proofsMetadata).supportsInterface(type(IProofsMetadata).interfaceId),
            'Must support IProofsMetadata'
        );
    }
}
