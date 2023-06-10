// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

/**
 * Enhances operation with strings that are not possible in the current Solidity version (v0.8.18)
 */
library StringsLib {
    /**
     * Gets length of the string
     * @param s Input string
     * @return The lenght of the string
     */
    function length(string memory s) internal pure returns (uint256) {
        return bytes(s).length;
    }
}
