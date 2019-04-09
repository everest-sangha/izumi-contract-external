pragma solidity ^0.5.2;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "./ITransferChecker.sol";
import "../regulator/IRegulatorService.sol";

// ERC1594 part: Transfer Validity Checker.
//  This checker simply uses a regulator service to process the actual verification.
contract TransferChecker is ERC20, ITransferChecker {

    // Pointer to the reg-service contract, publicly viewable
    IRegulatorService public reg;

    function _canTransfer(address _from, address _to, uint256 _value, bytes memory _data) internal view returns (byte, bytes32) {
        return reg.verifyTransfer(_from, _to, _value, _data);
    }

    function canTransferFrom(address _from, address _to, uint256 _value, bytes calldata _data) external view returns (byte, bytes32) {
        return reg.verifyTransfer(_from, _to, _value, _data);
    }

    function canTransfer(address _to, uint256 _value, bytes calldata _data) external view returns (byte, bytes32) {
        return reg.verifyTransfer(msg.sender, _to, _value, _data);
    }

}
