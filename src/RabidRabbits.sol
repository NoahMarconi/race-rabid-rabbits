// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import { ERC721 } from "@solady/tokens/ERC721.sol";
import { IERC20 } from "@openzeppelin/interfaces/IERC20.sol";
import { ClonesWithImmutableArgs } from "clones-with-immutable-args/src/ClonesWithImmutableArgs.sol";
import { Clone } from "clones-with-immutable-args/src/Clone.sol";

// can deploy on OP? and mainnet eth

// bunnies with rabies array storage, load to memory, operate on it, store again

// There are no bugs in the Rabbits token contract.
// It's there for reference but skip ahead to other contracts to manage your time.
contract Rabbits is ERC721 {
    /* --------------------------------- Storage -------------------------------- */

    string internal _name;
    string internal _symbol;
    address public deployer;

    /* --------------------------------- Errors --------------------------------- */

    error NotAuthorized();

    /* -------------------------------- Modifiers ------------------------------- */

    modifier onlyDeployer() {
        if (msg.sender != deployer) {
            revert NotAuthorized();
        }
        _;
    }

    /* ------------------------------- Constructor ------------------------------ */

    constructor() {
        _name = "RabidRabbits";
        _symbol = "RABID";

        deployer = msg.sender;
    }

    /* ---------------------------- Solady Overrides ---------------------------- */

    /// @dev Returns the token collection name.
    function name() public view override returns (string memory) {
        return _name;
    }

    /// @dev Returns the token collection symbol.
    function symbol() public view override returns (string memory) {
        return _symbol;
    }

    /// @dev Returns the Uniform Resource Identifier (URI) for token `id`.
    function tokenURI(uint256) public pure override returns (string memory) {
        return "{ fancyJson: true }";
    }

    function mint(address to, uint256 tokenId) public onlyDeployer {
        _mint(to, tokenId);
    }

    function burn(uint256 tokenId) public {
        _burn(tokenId);
    }
}

/// @notice Uses clones-with-immutable-args to avoid cost of storage reads.
///         See https://github.com/wighawag/clones-with-immutable-args
contract ResearchLab is Clone {
    function commitReseachResources() public { }

    function revealResearchResult() public { }

    function trulyRandomExternalCall(uint256 id) internal {
        // Update state at the same time
        //
        // delegatecall
    }
}

contract RabidRabbits {
    using ClonesWithImmutableArgs for address;

    /* ---------------------------------- Types --------------------------------- */

    enum Rabies {
        None,
        Symtomatic,
        Ded,
        Cured
    }

    struct Bunny {
        uint256 id;
        Rabies rabies;
        address owner;
        uint256 lastCheckUp;
    }

    /* -------------------------- Immutable / Constant -------------------------- */

    uint256 public constant ADOPTION_PRICE = 10 ether;
    uint256 public constant DR_FEES = 0.5 ether;
    uint256 public constant SECONDS_IN_DAY = 86_400;

    IERC20 immutable lidoToken;
    ResearchLab immutable researchLabImpl;

    address immutable cloneArgsTarget;

    /* --------------------------------- Storage -------------------------------- */

    Bunny[] public bunnies;
    Rabbits public rabbitToken;

    /* ------------------------------- Constructor ------------------------------ */

    constructor(IERC20 _lidoToken, address _cloneArgsTarget) {
        // Deploy contracts.
        rabbitToken = new Rabbits();
        researchLabImpl = new ResearchLab();

        // Set contract state.
        lidoToken = IERC20(_lidoToken); // Q about save gas by not casting 2x

        cloneArgsTarget = _cloneArgsTarget;
    }

    /* ------------------------ Public State Transitions ------------------------ */

    function adopt() public {
        lidoToken.transferFrom(msg.sender, address(this), ADOPTION_PRICE);
        rabbitToken.mint(msg.sender, bunnies.length);
        bunnies.push(Bunny(bunnies.length, Rabies.None, msg.sender, block.timestamp));
    }

    function checkUp(uint256 idx) public {
        // when missed checkup you definitely have rabies
        // when checkup on time, odds of getting rabies are 1/10000
    }

    function miracleCure(uint256 start, uint256 end) public { }

    function researchAndDevelopment() public {
        abi.encodePacked(arg);

        // clone multiple
        for (uint256 i = 0; i < 10; i++) {
            ResearchLab researchLab = ResearchLab(address(researchLabImpl).clone(cloneArgs));
            researchLab.commitReseachResources();
            researchLab.revealResearchResult();
        }
        // commit resources
        // reveal result
    }

    function burry(uint256 idx) public {
        // burn token
        // transfer ownership to address(0)
        // array mismanagement
    }

    // terminal state when burned by non deployer
}
