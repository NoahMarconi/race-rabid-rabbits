// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import { ERC721 } from "@solady/tokens/ERC721.sol";

// can deploy on OP?

// bunnies with rabies array storage, load to memory, operate on it, store again

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

contract RabidRabbits {
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
    }

    /* --------------------------------- Storage -------------------------------- */

    Bunny[] public bunnies;
    Rabbits rabbitToken;

    /* ------------------------------- Constructor ------------------------------ */

    constructor() {
        rabbitToken = new Rabbits();
    }

    // terminal state when burned by non deployer
}
