## EIP712DOMAIN_TYPEHASH

```solidity
bytes32 EIP712DOMAIN_TYPEHASH
```

## EIP712Domain

```solidity
struct EIP712Domain {
  string name;
  string version;
  uint256 chainId;
  address verifyingContract;
}
```

## EIP712PropertyType

```solidity
struct EIP712PropertyType {
  string name;
  string kind;
}
```

## hash

```solidity
function hash(struct EIP712Domain data) internal pure returns (bytes32)
```

## recover

```solidity
function recover(bytes32 message, bytes sig) internal pure returns (address)
```

