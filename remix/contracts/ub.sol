// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

import {ERC20, IERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Capped} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {Pausable} from "@openzeppelin/contracts/utils/Pausable.sol";

/// @title Unibase Token Contract
/// @notice Implements an ERC20 token with a cap, pausability, ownership, and a whitelist feature.
contract Unibase is Pausable, ERC20Capped, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");

    mapping(address => bool) private _isWhitelisted;

    event WhitelistUpdated(address indexed account, bool isWhitelisted);

    /// @notice Initializes the contract.
    /// @param name The name of the token.
    /// @param symbol The symbol of the token.
    /// @param cap The maximum total supply of the token (e.g., for 1 million tokens with 18 decimals, pass 1000000 * 10**18).
    /// @param admin The address to be set as the default admin of the token.
    /// @param pauser The address to be set as the pauser
    constructor(
        string memory name,
        string memory symbol,
        uint256 cap,
        address admin,
        address pauser
    ) ERC20(name, symbol) ERC20Capped(cap) {
        _grantRole(DEFAULT_ADMIN_ROLE, admin);
        _grantRole(PAUSER_ROLE, pauser);
        _setRoleAdmin(PAUSER_ROLE, PAUSER_ROLE);
        _pause();
    }

    /// @notice Allows the pause controller address to pause all token transfers for non-whitelisted addresses.
    function pause() external onlyRole(PAUSER_ROLE) {
        _pause();
    }

    /// @notice Allows the pause controller address to unpause the token transfers.
    function unpause() external onlyRole(PAUSER_ROLE) {
        _unpause();
    }

    /// @notice Set the minter address by granting MINTER_ROLE to the specified address.
    /// @param minter The address to be granted the MINTER_ROLE.
    function setMinter(address minter) external onlyRole(DEFAULT_ADMIN_ROLE) {
        require(minter != address(0), "Minter cannot be zero address");
        _grantRole(MINTER_ROLE, minter);
    }

    /// @notice Allows the minter to mint new tokens, up to the cap.
    /// @param to The address that will receive the minted tokens.
    /// @param amount The amount of tokens to mint.
    function mint(address to, uint256 amount) external onlyRole(MINTER_ROLE) {
        _mint(to, amount);
    }

    /// @notice Returns true if the account is whitelisted.
    /// @param account The address to check.
    function isWhitelisted(address account) external view returns (bool) {
        return _isWhitelisted[account];
    }

    /// @notice Adds an address to the whitelist.
    /// @param account The address to add to the whitelist.
    function addToWhitelist(address account) external onlyRole(PAUSER_ROLE) {
        require(account != address(0), "cannot whitelist the zero address");
        _isWhitelisted[account] = true;
        emit WhitelistUpdated(account, true);
    }

    /// @notice Removes an address from the whitelist.
    /// @param account The address to remove from the whitelist.
    function removeFromWhitelist(
        address account
    ) external onlyRole(PAUSER_ROLE) {
        require(account != address(0), "cannot un-whitelist the zero address");
        _isWhitelisted[account] = false;
        emit WhitelistUpdated(account, false);
    }

    /// @notice Checks if the contract is paused before every transfer, mint, or burn, and verifies whitelist status.
    function _update(
        address from,
        address to,
        uint256 value
    ) internal virtual override {
        if (paused()) {
            bool isMinting = from == address(0);
            bool isBurning = to == address(0);
            bool isWhitelistedTransfer = _isWhitelisted[from] &&
                _isWhitelisted[to];
            require(
                isMinting || isBurning || isWhitelistedTransfer,
                "Token: transfer while paused (not whitelisted)"
            );
        }
        super._update(from, to, value);
    }

    /// @notice Recover ERC20 tokens mistakenly sent to this contract.
    /// @param token The address of the ERC20 token contract.
    /// @param to The address to receive the recovered tokens.
    /// @param amount The amount of tokens to recover.
    event ERC20Recovered(
        address indexed token,
        address indexed to,
        uint256 amount
    );

    function recoverERC20(
        address token,
        address to,
        uint256 amount
    ) external onlyRole(DEFAULT_ADMIN_ROLE) {
        require(to != address(0), "cannot send to zero address");
        require(token != address(0), "token address cannot be zero");
        require(amount > 0, "amount must be greater than zero");
        bool success = IERC20(token).transfer(to, amount);
        require(success, "ERC20 transfer failed");
        emit ERC20Recovered(token, to, amount);
    }
}
