pragma solidity ^0.5.2;

import "openzeppelin-solidity/contracts/access/Roles.sol";

/**
 * @title OpenZeppelin based Role: a regulation service appointer is able to decide what kinds of restrictions transfers follow
 */
contract RegServAppointerRole {
    using Roles for Roles.Role;

    event RegServAppointerAdded(address indexed account);
    event RegServAppointerRemoved(address indexed account);

    Roles.Role private _appointers;

    constructor () internal {
        _addRegServAppointer(msg.sender);
    }

    modifier onlyRegServAppointer() {
        require(isRegServAppointer(msg.sender));
        _;
    }

    function isRegServAppointer(address account) public view returns (bool) {
        return _appointers.has(account);
    }

    function addRegServAppointer(address account) public onlyRegServAppointer {
        _addRegServAppointer(account);
    }

    function renounceRegServAppointer() public {
        _removeRegServAppointer(msg.sender);
    }

    function _addRegServAppointer(address account) internal {
        _appointers.add(account);
        emit RegServAppointerAdded(account);
    }

    function _removeRegServAppointer(address account) internal {
        _appointers.remove(account);
        emit RegServAppointerRemoved(account);
    }
}
