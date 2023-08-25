// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

// can deploy on OP?

// bunnies with rabies array storage, load to memory, operate on it, store again

contract RabidRabbits {

    /* ---------------------------------- Types --------------------------------- */

    enum Rabies { None, Symtomatic, Ded, Cured }

    struct Bunny {
        uint256 id;
        Rabies rabies;
        address owner;
    
    }

    /* --------------------------------- Storage -------------------------------- */

    Bunny[] public bunnies;


    /* ------------------------------- Constructor ------------------------------ */

    constructor() {
        bunnies.push(Bunny(0, Rabies.None, address(0)));
    }

}
