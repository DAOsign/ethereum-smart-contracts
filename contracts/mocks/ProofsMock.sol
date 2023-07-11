// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import { Proofs } from '../Proofs.sol';

// TODO: delete this mock if not used
/**
 * Stores DAOsign proofs.
 *
 * Note
 * Proof-of-Authority = PoAu
 * Proof-of-Signature = PoSi
 * Proof-of-Agreement = PoAg
 */
contract ProofsMock is Proofs {
    // solhint-disable-next-line no-empty-blocks
    constructor(address _proofsMetadata) Proofs(_proofsMetadata) {}
}
