pragma solidity 0.4.24;

import "./SafeMath.sol";

/**
 * @title Roles
 * @dev Library for managing addresses assigned to a Role.
 * @dev more info: https://github.com/OpenZeppelin/openzeppelin-contracts/tree/release-v2.3.0/contracts/access
 */
library Roles {
    struct Role {
        mapping (address => bool) bearer;
    }

    /**
     * @dev Give an account access to this role.
     */
    function add(Role storage role, address account) internal {
        require(!has(role, account), "Roles: account already has role");
        role.bearer[account] = true;
    }

    /**
     * @dev Remove an account's access to this role.
     */
    function remove(Role storage role, address account) internal {
        require(has(role, account), "Roles: account does not have role");
        role.bearer[account] = false;
    }

    /**
     * @dev Check if an account has this role.
     * @return bool
     */
    function has(Role storage role, address account) internal view returns (bool) {
        require(account != address(0), "Roles: account is the zero address");
        return role.bearer[account];
    }
}

/**
 * @title SuperAdminRole
 * @dev SuperAdmins are responsible for assigning and removing other Role accounts.
 */
contract SuperAdminRole {
    using Roles for Roles.Role;
    using SafeMath for uint256;

    event SuperAdminAdded(address indexed account);
    event SuperAdminRemoved(address indexed account);

    Roles.Role private _SuperAdmins;
    address[] public superAdminAddress;

    constructor () public {
        _addSuperAdmin(msg.sender);
    }

    modifier onlySuperAdmin() {
        require(isSuperAdmin(msg.sender), "SuperAdminRole: caller does not have the SuperAdmin role");
        _;
    }

    /**
     * @dev isSuperAdmin check if the account is super admin
     * @param account the address that will be checked
     * @return bool, true if account is super admin.
     */
    function isSuperAdmin(address account) public view returns (bool) {
        return _SuperAdmins.has(account);
    }

    /**
     * @dev superAdminAmount get the amount of super admin
     * @return the amount of super admin
     */
    function superAdminAmount() public view returns (uint256) {
        return superAdminAddress.length;
    }

    /**
     * @dev addSuperAdmin add another address to super admin
     * @param account the address that will be added
     * @notice only super admin can execute this function
     */
    function addSuperAdmin(address account) public onlySuperAdmin {
        _addSuperAdmin(account);
    }

    /**
     * @dev renounceWhitelistAdmin remove himself super admin
     * @notice only super admin can execute this function
     * @notice this function can be executed only when superAdminAmount bigger than 1
     */
    function renounceWhitelistAdmin() public {
        require(superAdminAmount() > 1, "SuperAdmins should more than 0");
        _removeSuperAdmin(msg.sender);
    }

    function _addSuperAdmin(address account) internal {
        _SuperAdmins.add(account);
        superAdminAddress.push(account);

        emit SuperAdminAdded(account);
    }

    function _removeSuperAdmin(address account) internal {
        require(_SuperAdmins.has(account), "Roles: account does not have role");

        _SuperAdmins.remove(account);

        uint256 _i = 0;
        while (superAdminAddress[_i] != account) {
            _i++;
        }
        uint256 _length = superAdminAddress.length;
        superAdminAddress[_i] = superAdminAddress[_length-1];
        superAdminAddress.length = superAdminAddress.length.sub(1);

        emit SuperAdminRemoved(account);
    }
}


/**
 * @title WhitelistedRole
 * @dev Whitelisted accounts have been approved by a WhitelistAdmin to perform certain actions (e.g. participate in a
 * crowdsale). This role is special in that the only accounts that can add it are WhitelistAdmins (who can also remove
 * it), and not Whitelisteds themselves.
 */
contract WhitelistedRole is SuperAdminRole {
    using Roles for Roles.Role;

    event WhitelistedAdded(address indexed account);
    event WhitelistedRemoved(address indexed account);

    Roles.Role private _whitelisteds;
    address[] public whitelistedAddress;

    modifier onlyWhitelisted() {
        require(isWhitelisted(msg.sender), "WhitelistedRole: caller does not have the Whitelisted role");
        _;
    }

    /**
     * @dev isWhitelisted check if the account is in white list
     * @param account the address that will be checked
     * @return bool, return true if account is in white list
     */
    function isWhitelisted(address account) public view returns (bool) {
        return _whitelisteds.has(account);
    }

    /**
     * @dev whitelistedAmount get the amount of white list
     * @return the amount of white list
     */
    function whitelistedAmount() public view returns (uint256) {
        return whitelistedAddress.length;
    }

    /**
     * @dev addWhitelisted add another address to white list
     * @param account the address that will be added
     * @notice only super admin can execute this function
     */
    function addWhitelisted(address account) public onlySuperAdmin {
        _addWhitelisted(account);
    }

    /**
     * @dev removeWhitelisted remove someone from white list
     * @param account the address that whill be remove
     * @notice only super admin can execute this function
     */
    function removeWhitelisted(address account) public onlySuperAdmin {
        _removeWhitelisted(account);
    }

    function _addWhitelisted(address account) internal {
        _whitelisteds.add(account);
        whitelistedAddress.push(account);

        emit WhitelistedAdded(account);
    }

    function _removeWhitelisted(address account) internal {
        require(_whitelisteds.has(account), "Roles: account does not have role");

        _whitelisteds.remove(account);

        uint256 _i = 0;
        while (whitelistedAddress[_i] != account) {
            _i++;
        }
        uint256 _length = whitelistedAddress.length;
        whitelistedAddress[_i] = whitelistedAddress[_length-1];
        whitelistedAddress.length = whitelistedAddress.length.sub(1);

        emit WhitelistedRemoved(account);
    }
}