pragma solidity ^0.5.2;

// ERC1594 part: Token Issuance
interface ITokenIssuance {

    function isIssuable() external view returns (bool);
    function issue(address _tokenHolder, uint256 _value, bytes calldata _data) external;

    event Issued(address indexed _operator, address indexed _to, uint256 _value, bytes _data);

}