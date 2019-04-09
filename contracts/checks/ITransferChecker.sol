pragma solidity ^0.5.2;

// ERC1594 part: Transfer Validity Checker
interface ITransferChecker {

    function canTransferFrom(address _from, address _to, uint256 _value, bytes calldata _data) external view returns (byte, bytes32);
    function canTransfer(address _to, uint256 _value, bytes calldata _data) external view returns (byte, bytes32);

}