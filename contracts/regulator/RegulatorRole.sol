pragma solidity ^0.5.2;

import "openzeppelin-solidity/contracts/access/Roles.sol";

/**
 * @title OpenZeppelin based Role: a regulator is able to do force transfers and freeze accounts.
 */
contract RegulatorRole {
    using Roles for Roles.Role;

    event RegulatorAdded(address indexed account);
    event RegulatorRemoved(address indexed account);

    Roles.Role private _regulators;

    constructor () internal {
        _addRegulator(msg.sender);
    }

    modifier onlyRegulator() {
        require(isRegulator(msg.sender));
        _;
    }

    function isRegulator(address account) public view returns (bool) {
        return _regulators.has(account);
    }

    function addRegulator(address account) public onlyRegulator {
        _addRegulator(account);
    }

    function renounceRegulator() public {
        _removeRegulator(msg.sender);
    }

    function _addRegulator(address account) internal {
        _regulators.add(account);
        emit RegulatorAdded(account);
    }

    function _removeRegulator(address account) internal {
        _regulators.remove(account);
        emit RegulatorRemoved(account);
    }
}
