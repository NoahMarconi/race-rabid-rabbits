// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { PRBTest } from "@prb/test/PRBTest.sol";
import { console2 } from "forge-std/console2.sol";
import { StdCheats } from "forge-std/StdCheats.sol";
import { RabidRabbits, TrulyRandomOracleMock } from "../src/RabidRabbits.sol";
import { IERC20 } from "@openzeppelin/interfaces/IERC20.sol";

/// @dev If this is your first time with Forge, read this tutorial in the Foundry Book:
/// https://book.getfoundry.sh/forge/writing-tests
contract RabidRabbitsTest is PRBTest, StdCheats {
    error NoAPIKey();

    RabidRabbits internal rabidRabbits;
    uint256 mainnetFork;

    modifier fromForked() {
        vm.selectFork(mainnetFork);
        _;
    }
    /// @dev A function invoked before each test case is run.

    function setUp() public virtual {
        // Revert if there is no API key.
        string memory alchemyApiKey = vm.envOr("API_KEY_ALCHEMY", string(""));
        if (bytes(alchemyApiKey).length == 0) {
            revert NoAPIKey();
        }

        mainnetFork = vm.createSelectFork({ urlOrAlias: "mainnet", blockNumber: 18_000_080 });
        address trulyRandomOracleMock = address(new TrulyRandomOracleMock());
        IERC20 lidoToken = IERC20(0x5A98FcBEA516Cf06857215779Fd812CA3beF1B32);

        // Instantiate the contract-under-test.
        rabidRabbits = new RabidRabbits(lidoToken, trulyRandomOracleMock);
    }

    function test_EntropySuccess() external fromForked {
        uint256 idx = mintOne();
        rabidRabbits.researchAndDevelopment(idx);
        rabidRabbits.labsOf(idx, 0).researchEndeavors(0);
        rabidRabbits.labsOf(idx, 0).entropy();
    }

    function test_ArrayNotThere() external fromForked {
        uint256 idx = mintOne();
        mintOne();
        mintOne();
        rabidRabbits.researchAndDevelopment(idx);

        vm.warp(block.timestamp + 8 days);
        rabidRabbits.burry(idx);
        rabidRabbits.labsOf(idx, 0);
    }

    function mintOne() internal returns (uint256) {
        rabidRabbits.adopt();
        return rabidRabbits.rabbitToken().balanceOf(address(this)) - 1;
    }
}
