## StringUtils

Enhances operation with strings that are not possible in the current Solidity version (v0.8.18)

### equal

```solidity
function equal(string _s1, string _s2) internal pure returns (bool)
```

_Compares two strings_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _s1 | string | One string |
| _s2 | string | Another string |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bool | Are string equal |

### length

```solidity
function length(string _s) public pure returns (uint256)
```

Gets length of the string

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _s | string | Input string |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | res The lenght of the string |

