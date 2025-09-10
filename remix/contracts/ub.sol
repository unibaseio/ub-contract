// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

/**
 * @title Open Token
 * @dev Implementation of the Open Token with burning capability
 * @custom:security-contact security@openledger.xyz
 */
contract UB is ERC20, ERC20Burnable {
    /**
     * @notice ERC20 Name of the token: Open
     * @dev ERC20 function name() public view returns (string)
     * @dev This internal constant is used to initialize the token name;
     *      the public name() function is inherited from ERC20.
     */
    string internal constant NAME = "Unibase";

    /**
     * @notice ERC20 Symbol of the token: OPEN
     * @dev ERC20 function symbol() public view returns (string)
     * @dev This internal constant is used to initialize the token symbol;
     *      the public symbol() function is inherited from ERC20.
     */
    string internal constant SYMBOL = "UB";

    /**
     * @notice Creates `amount` tokens and assigns them to `recipient`, increasing the total supply
     * @dev Sets the total supply to 1 billion tokens, all assigned to the deployer
     * @param recipient The address that will receive the minted tokens
     */
    constructor(address recipient) ERC20(NAME, SYMBOL) {
        _mint(recipient, 10_000_000_000 * 10 ** decimals());
    }
}