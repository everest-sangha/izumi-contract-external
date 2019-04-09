pragma solidity ^0.5.2;

// ERC1594 part: Token Redemption (i.e. permissible burning)
interface ITokenRedemption {

    function redeem(uint256 _value, bytes calldata _data) external;
    function redeemFrom(address _tokenHolder, uint256 _value, bytes calldata _data) external;

    //_operator is underspecified in spec, and unused in ERC-1594
    event Redeemed(address indexed _operator, address indexed _from, uint256 _value, bytes _data);
    event ForceRedeemed(address indexed _operator, address indexed _from, uint256 _value, bytes _data, address reason);

}