// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import { ITradeFI } from '../interfaces/ITradeFI.sol';

contract MockTradeFI is ITradeFI {
    address private admin = msg.sender;

    function getAdmin() external view returns (address) {
        return admin;
    }

    function setAdmin(address _admin) external {
        admin = _admin;
    }
}
