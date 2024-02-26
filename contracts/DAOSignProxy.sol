// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { Ownable } from '@openzeppelin/contracts/access/Ownable.sol';
import { Proxy } from '@openzeppelin/contracts/proxy/Proxy.sol';
import { UpgradeableBeacon } from '@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol';

contract DAOSignProxy is Proxy, UpgradeableBeacon {
    constructor(address impl, address owner) UpgradeableBeacon(impl, owner) {}

    function _implementation() internal view override returns (address) {
        return implementation();
    }

    receive() external payable virtual {
        _fallback();
    }
}
