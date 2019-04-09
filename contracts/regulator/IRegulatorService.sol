pragma solidity ^0.5.2;

interface IRegulatorService {

    function freeze(bool status) external;
    function verifyTransfer(address _from, address _to, uint256 _value, bytes calldata _data) external view returns (byte, bytes32);

}