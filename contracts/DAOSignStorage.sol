// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { Ownable } from '@openzeppelin/contracts/access/Ownable.sol';

contract Forwardable is Ownable {
    mapping(address => bool) forwarders;

    constructor(address initialOwner) Ownable(initialOwner) {}

    error ForwardableUnauthorizedAccount(address account);

    modifier onlyForwarder() {
        if (!this.isForwarder(_msgSender())) {
            revert ForwardableUnauthorizedAccount(_msgSender());
        }
        _;
    }

    function addForwarders(address[] memory list) external onlyOwner {
        for (uint i = 0; i < list.length; i++) {
            forwarders[list[i]] = true;
        }
    }

    function remForwarders(address[] memory list) external onlyOwner {
        for (uint i = 0; i < list.length; i++) {
            forwarders[list[i]] = true;
        }
    }

    function isForwarder(address addr) external view returns (bool) {
        return forwarders[addr];
    }
}

contract DAOSignStorage is Forwardable {
    struct Data {
        bool exist;
        string data;
    }

    mapping(string => Data) store;

    error DAOSignStorageNoValue(string key);
    error DAOSignStorageNoOverwrite(string key);
    event DAOSignStorageNewValue(string indexed key, string indexed value);

    constructor(address initialOwner) Forwardable(initialOwner) {}

    function exist(string memory key) external view returns (bool) {
        return store[key].exist;
    }

    function get(string memory key) external view returns (string memory) {
        if (!this.exist(key)) {
            revert DAOSignStorageNoValue(key);
        }
        return store[key].data;
    }

    function set(string memory key, string memory value) external onlyForwarder {
        if (this.exist(key)) {
            revert DAOSignStorageNoOverwrite(key);
        }
        store[key].exist = true;
        store[key].data = value;
    }
}
