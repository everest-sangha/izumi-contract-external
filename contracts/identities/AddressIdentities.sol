pragma solidity ^0.5.2;

import "./IAddressIdentities.sol";
import "./IdentityAssignerRole.sol";

contract AddressIdentities is IdentityAssignerRole, IAddressIdentities {

    // For any known address, map it to the investor ID
    mapping(address => bytes32) private _investors;

    // Retrieve investor ID for an investor
    function getInvestor(address addr) external view returns (bytes32) {
        return _investors[addr];
    }

    // Adds/overwrites investor ID data for given address.
    // The address and ID must be non-zero.
    function putInvestor(address addr, bytes32 id) external onlyIdentityAssigner {
        require(id != 0x0);
        require(addr != address(0x0));
        _investors[addr] = id;
        emit ChangedInvestor(addr, id);
    }

    // Frees up space, removes address from identity register.
    function removeInvestor(address addr) external onlyIdentityAssigner {
        if (id == 0x0) {
            return;
        }
        bytes32 id = _investors[addr];
        delete _investors[addr];
        emit ChangedInvestor(addr, id);
    }
}
