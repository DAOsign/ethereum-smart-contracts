## DAOSignProxy

### constructor

```solidity
constructor(address impl, address owner) public
```

### _implementation

```solidity
function _implementation() internal view returns (address)
```

_This is a virtual function that should be overridden so it returns the address to which the fallback
function and {_fallback} should delegate._

### receive

```solidity
receive() external payable virtual
```

