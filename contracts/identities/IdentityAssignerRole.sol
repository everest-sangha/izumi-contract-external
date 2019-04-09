pragma solidity ^0.5.2;

import "openzeppelin-solidity/contracts/access/Roles.sol";

/**
 * @title OpenZeppelin based Role: an identity assigner is able to assign (new) identities to ETH addresses.
 */
contract IdentityAssignerRole {
    using Roles for Roles.Role;

    event IdentityAssignerAdded(address indexed account);
    event IdentityAssignerRemoved(address indexed account);

    Roles.Role private _issuers;

    constructor () internal {
        _addIdentityAssigner(msg.sender);
    }

    modifier onlyIdentityAssigner() {
        require(isIdentityAssigner(msg.sender));
        _;
    }

    function isIdentityAssigner(address account) public view returns (bool) {
        return _issuers.has(account);
    }

    function addIdentityAssigner(address account) public onlyIdentityAssigner {
        _addIdentityAssigner(account);
    }

    function renounceIdentityAssigner() public {
        _removeIdentityAssigner(msg.sender);
    }

    function _addIdentityAssigner(address account) internal {
        _issuers.add(account);
        emit IdentityAssignerAdded(account);
    }

    function _removeIdentityAssigner(address account) internal {
        _issuers.remove(account);
        emit IdentityAssignerRemoved(account);
    }
}
