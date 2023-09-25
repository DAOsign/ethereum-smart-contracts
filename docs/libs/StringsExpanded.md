## StringsExpanded

Enhances operation with strings that are not possible in the current Solidity version (v0.8.18)

### length

```solidity
function length(string s) public pure returns (uint256)
```

Gets length of the string

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| s | string | Input string |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | res The lenght of the string |

### concat

```solidity
function concat(string s1, string s2) public pure returns (string)
```

Combines two input strings into one

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| s1 | string | The first string |
| s2 | string | The second string |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | string | res The resultant string created by merging s1 and s2 |

### toString

```solidity
function toString(uint256 x) public pure returns (string)
```

Converts a `uint256` to its ASCII `string` decimal representation
Inspired by OraclizeAPI's implementation - MIT licence
https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| x | uint256 | Input number |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | string | res Number represented as a string |

### toString

```solidity
function toString(address addr) public pure returns (string)
```

Converts an Ethereum address to a string
Note: only lowercase letters are used

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| addr | address | The Ethereum address to convert |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | string | res The string representation of the Ethereum address, including the '0x' prefix |

### toHexString

```solidity
function toHexString(bytes _bytes) public pure returns (string)
```

Converts Solidity bytes to a string

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _bytes | bytes | Input bytes |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | string | res Input bytes in a string format with '0x' prefix |

