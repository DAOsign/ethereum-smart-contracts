// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

/**
 * Enhances operation with strings that are not possible in the current Solidity version (v0.8.18)
 */
library StringsExpanded {
    /**
     * Gets length of the string
     * @param s Input string
     * @return The lenght of the string
     */
    function length(string memory s) public pure returns (uint256) {
        return bytes(s).length;
    }

    /**
     * Combines two input strings into one
     * @param s1 The first string
     * @param s2 The second string
     * @return res The resultant string created by merging s1 and s2
     */
    function concat(string memory s1, string memory s2) internal pure returns (string memory) {
        return string(abi.encodePacked(s1, s2));
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` decimal representation
     * @notice Inspired by OraclizeAPI's implementation - MIT licence
     * https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
     * @param x Input number
     * @return res Number represented as a string
     */
    function toString(uint256 x) internal pure returns (string memory) {
        if (x == 0) {
            return '0';
        }
        uint256 _temp = x;
        uint256 _digits;
        while (_temp != 0) {
            _digits++;
            _temp /= 10;
        }
        bytes memory _buffer = new bytes(_digits);
        while (x != 0) {
            _digits -= 1;
            _buffer[_digits] = bytes1(uint8(48 + uint256(x % 10)));
            x /= 10;
        }
        return string(_buffer);
    }

    /**
     * Converts an Ethereum address to a string
     * @param addr The Ethereum address to convert
     * @return res The string representation of the Ethereum address, including the '0x' prefix
     */
    function toString(address addr) public pure returns (string memory) {
        bytes32 _bytes = bytes32(uint256(uint160(addr)));
        bytes memory HEX = '0123456789abcdef';
        bytes memory str = new bytes(42);
        str[0] = '0';
        str[1] = 'x';
        for (uint i = 0; i < 20; i++) {
            str[i * 2 + 2] = HEX[uint8(_bytes[i + 12] >> 4)];
            str[i * 2 + 3] = HEX[uint8(_bytes[i + 12] & 0x0f)];
        }
        return string(str);
    }

    function toHexString(bytes memory _bytes) internal pure returns (string memory) {
        bytes memory hexString = new bytes(_bytes.length * 2);

        uint256 index = 0;
        for (uint256 i = 0; i < _bytes.length; i++) {
            uint256 value = uint256(uint8(_bytes[i]));

            bytes1 highNibble = bytes1(uint8((value & 0xf0) >> 4));
            bytes1 lowNibble = bytes1(uint8(value & 0x0f));

            hexString[index++] = charToHex(highNibble);
            hexString[index++] = charToHex(lowNibble);
        }

        return string(abi.encodePacked('0x', string(hexString)));
    }

    function charToHex(bytes1 _char) private pure returns (bytes1) {
        if (uint8(_char) < 10) {
            return bytes1(uint8(_char) + 0x30); // '0' to '9'
        } else {
            return bytes1(uint8(_char) + 0x57); // 'a' to 'f'
        }
    }
}
