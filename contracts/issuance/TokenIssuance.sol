pragma solidity ^0.5.2;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "./IssuerRole.sol";
import "../checks/TransferChecker.sol";
import "./ITokenIssuance.sol";

// ERC1594 part: Token Issuance
contract TokenIssuance is ERC20, TransferChecker, IssuerRole, ITokenIssuance {
    using SafeMath for uint256;

    // maximum issued tokens, i.e. capacity of the token
    uint256 public capacity;

    constructor(uint256 _cap) internal {
        capacity = _cap;
    }

    // Check if the tokens can be issued. For basic implementation restriction is only on capacity.
    // However, for actual implementation, time might be another restriction
    function _issuanceAllowed(uint256 amount) internal view returns (bool) {
        uint256 hypotheticalSupply = totalSupply().add(amount);
        return (hypotheticalSupply <= capacity);
    }

    // Check if the token has reached its cap by external parties
    function isIssuable() external view returns (bool) {
        return _issuanceAllowed(1 wei);
    }

    function issue(address _tokenHolder, uint256 _value, bytes calldata _data) external onlyIssuer {
        require(_issuanceAllowed(_value));
        (byte status, /* unused bytes32 reason */) = _canTransfer(address(0x0), _tokenHolder, _value, _data);
        // require status to be OK. I.e. the holder is allowed to receive tokens.
        require(status == hex"11");

        _mint(_tokenHolder, _value);
        
        emit Issued(msg.sender, _tokenHolder, _value, _data);
    }

}