// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

bytes32 constant EIP712DOMAIN_TYPEHASH = keccak256(
    'EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'
);

struct EIP712Domain {
    string name;
    string version;
    uint256 chainId;
    address verifyingContract;
}

struct EIP712PropertyType {
    string name;
    string kind;
}

function hash(EIP712Domain memory data) pure returns (bytes32) {
    bytes memory encoded = abi.encode(
        EIP712DOMAIN_TYPEHASH,
        keccak256(bytes(data.name)),
        keccak256(bytes(data.version)),
        data.chainId,
        data.verifyingContract
    );
    return keccak256(encoded);
}

function recover(bytes32 message, bytes memory sig) pure returns (address) {
    bytes32 r;
    bytes32 s;
    uint8 v;

    // Check the signature length
    if (sig.length != 65) {
        return (address(0));
    }

    // Divide the signature in r, s and v variables
    assembly {
        r := mload(add(sig, 32))
        s := mload(add(sig, 64))
        v := byte(0, mload(add(sig, 96)))
    }

    // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
    if (v < 27) {
        v += 27;
    }

    // If the version is correct return the signer address
    if (v != 27 && v != 28) {
        return (address(0));
    } else {
        return ecrecover(message, v, r, s);
    }
}
