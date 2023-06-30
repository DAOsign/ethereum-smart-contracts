// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

// import 'hardhat/console.sol';

import { IERC165 } from '@openzeppelin/contracts/utils/introspection/IERC165.sol';
import { ERC165Checker } from '@openzeppelin/contracts/utils/introspection/ERC165Checker.sol';
import { IProofsMetadata } from './interfaces/IProofsMetadata.sol';
import { Strings } from './libs/Strings.sol';

/**
 * Stores DAOsign proofs.
 */
contract Proofs {
    using Strings for string;
    using Strings for uint256;
    using Strings for address;

    address public proofsMetadata;

    constructor(address _proofsMetadata) {
        require(
            ERC165Checker.supportsERC165(_proofsMetadata) &&
                IERC165(_proofsMetadata).supportsInterface(type(IProofsMetadata).interfaceId),
            'Must support IProofsMetadata'
        );
        proofsMetadata = _proofsMetadata;
    }

    /**
    Public:
    - Create Proof-of-Authority data (given a creator's address, agreementFileCID, and the list of signers)
    - Create Proof-of-Signature (given a signer's address and Proof-of-Authority IPFS CID)
    - Sign (off-chain), store & verify signature of the data (used for any proof), generate proof IPFS CID

    System:
    - autogenereate Proof-of-Agreement
     */

    function getProofOfAuthorityData(
        address creator,
        address[] calldata signers,
        string calldata agreementFileCID,
        string calldata version
    ) public view returns (string memory) {
        return
            string(
                abi.encodePacked(
                    IProofsMetadata(proofsMetadata).proofsMetadata('Proof-of-Authority', version),
                    ',"message":',
                    getProofOfAuthorityDataMessage(creator, signers, agreementFileCID),
                    '}'
                )
            );
    }

    // TODO: make internal
    function getProofOfAuthorityDataMessage(
        address creator,
        address[] calldata signers,
        string calldata agreementFileCID
    ) public view returns (string memory) {
        string memory message = string(
            abi.encodePacked(
                '{"from":"',
                creator.toString(),
                '","agreementFileCID":"',
                agreementFileCID,
                '","signers":',
                generateSignersJSON(signers),
                ',"app":"daosign","timestamp":',
                block.timestamp.toString(),
                ',"metadata":{}}'
            )
        );

        return message;
    }

    // TODO: make internal
    function generateSignersJSON(address[] calldata signers) public pure returns (string memory) {
        string memory res = '[';

        for (uint256 i = 0; i < signers.length; i++) {
            res = res.concat(
                string(abi.encodePacked('{"address":"', signers[i].toString(), '","metadata":{}}'))
            );
            if (i != signers.length - 1) {
                res = res.concat(',');
            }
        }

        res = res.concat(']');

        return res;
    }
}
