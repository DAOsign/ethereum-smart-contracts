// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import { StringsLib } from '../libs/StringsLib.sol';

/**
 * Enhances operation with strings that are not possible in the current Solidity version (v0.8.18)
 */
contract StringsLibTest {
    using StringsLib for string;

    function length(string memory s) internal pure returns (uint256) {
        return s.length();
    }
}
