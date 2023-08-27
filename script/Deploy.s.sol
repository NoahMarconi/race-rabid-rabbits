// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <=0.9.0;

import { RabidRabbits, TrulyRandomOracleMock } from "../src/RabidRabbits.sol";
import { IERC20 } from "@openzeppelin/interfaces/IERC20.sol";
import { BaseScript } from "./Base.s.sol";

/// @dev See the Solidity Scripting tutorial: https://book.getfoundry.sh/tutorials/solidity-scripting
contract Deploy is BaseScript {
    function run() public broadcast returns (RabidRabbits rabidRabbits) {
        address trulyRandomOracleMock = address(new TrulyRandomOracleMock());
        IERC20 lidoToken = IERC20(0x5A98FcBEA516Cf06857215779Fd812CA3beF1B32);
        rabidRabbits = new RabidRabbits(lidoToken, trulyRandomOracleMock);
    }
}
