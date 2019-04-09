pragma solidity ^0.5.2;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "./ITokenRedemption.sol";
import "../checks/TransferChecker.sol";

// ERC1594 part: Token Redemption
contract TokenRedemption is ERC20, TransferChecker, ITokenRedemption {

    // Token Redemption
    function redeem(uint256 _value, bytes calldata _data) external {
        // If the token holder can transfer to 0, the holder can redeem (effectively burn) the given amount of tokens
        (byte status, /* unused bytes32 reason */) = _canTransfer(msg.sender, address(0x0), _value, _data);
        require(status == hex"11");
        _burn(msg.sender, _value);

        emit Redeemed(msg.sender, msg.sender, _value, "");
    }

    function redeemFrom(address _tokenHolder, uint256 _value, bytes calldata _data) external {
        (byte status, bytes32 reason) = _canTransfer(_tokenHolder, address(0x0), _value, _data);
        require(status == hex"11");

        // If the status was OK, but it still had a special reason (non zero), then it is a force redemption.
        if (reason != 0x0) {
            _burn(_tokenHolder, _value);
            emit ForceRedeemed(msg.sender, _tokenHolder, _value, "", address(uint160(uint256(reason))));
        } else {
            _burnFrom(_tokenHolder, _value);
            emit Redeemed(msg.sender, _tokenHolder, _value, "");
        }
    }

}