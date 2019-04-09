pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol";
import "ERC1594.sol";

// TODO: SecurityToken should be "is" ISecurityToken
contract SecurityToken is ERC20, ERC1594, ERC20Detailed {

    constructor (string memory name, string memory symbol, uint8 decimals, uint256 cap)
    ERC1594(cap)
    ERC20Detailed(name, symbol, decimals) public {
    }
}
