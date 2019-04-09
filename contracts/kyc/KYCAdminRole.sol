pragma solidity ^0.5.2;

import "openzeppelin-solidity/contracts/access/Roles.sol";

/**
 * @title OpenZeppelin based Role: an KYC admin is able to introduce new KYC data.
 */
contract KYCAdminRole {
    using Roles for Roles.Role;

    event KYCAdminAdded(address indexed account);
    event KYCAdminRemoved(address indexed account);

    Roles.Role private _issuers;

    constructor () internal {
        _addKYCAdmin(msg.sender);
    }

    modifier onlyKYCAdmin() {
        require(isKYCAdmin(msg.sender));
        _;
    }

    function isKYCAdmin(address account) public view returns (bool) {
        return _issuers.has(account);
    }

    function addKYCAdmin(address account) public onlyKYCAdmin {
        _addKYCAdmin(account);
    }

    function renounceKYCAdmin() public {
        _removeKYCAdmin(msg.sender);
    }

    function _addKYCAdmin(address account) internal {
        _issuers.add(account);
        emit KYCAdminAdded(account);
    }

    function _removeKYCAdmin(address account) internal {
        _issuers.remove(account);
        emit KYCAdminRemoved(account);
    }
}
