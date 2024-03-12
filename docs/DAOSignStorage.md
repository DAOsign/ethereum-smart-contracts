## Forwardable

### forwarders

```solidity
mapping(address => bool) forwarders
```

### constructor

```solidity
constructor(address initialOwner) public
```

### ForwardableUnauthorizedAccount

```solidity
error ForwardableUnauthorizedAccount(address account)
```

### onlyForwarder

```solidity
modifier onlyForwarder()
```

### addForwarders

```solidity
function addForwarders(address[] list) external
```

### remForwarders

```solidity
function remForwarders(address[] list) external
```

### isForwarder

```solidity
function isForwarder(address addr) external view returns (bool)
```

## DAOSignStorage

### Data

```solidity
struct Data {
  bool exist;
  string data;
}
```

### store

```solidity
mapping(string => struct DAOSignStorage.Data) store
```

### DAOSignStorageNoValue

```solidity
error DAOSignStorageNoValue(string key)
```

### DAOSignStorageNoOverwrite

```solidity
error DAOSignStorageNoOverwrite(string key)
```

### DAOSignStorageNewValue

```solidity
event DAOSignStorageNewValue(string key, string value)
```

### constructor

```solidity
constructor(address initialOwner) public
```

### exist

```solidity
function exist(string key) external view returns (bool)
```

### get

```solidity
function get(string key) external view returns (string)
```

### set

```solidity
function set(string key, string value) external
```

