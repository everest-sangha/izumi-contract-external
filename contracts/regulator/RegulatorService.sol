pragma solidity ^0.5.2;

import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";
import "./IRegulatorService.sol";
import "../kyc/IStoreKYC.sol";
import "../identities/IAddressIdentities.sol";
import "./RegulatorRole.sol";

contract RegulatorService is RegulatorRole, IRegulatorService {

    IERC20 public token;
    IAddressIdentities public investors;
    IStoreKYC public kyc;

    bool public frozen;

    constructor(address _token, address _investors, address _kyc) public {
        token = IERC20(_token);
        investors = IAddressIdentities(_investors);
        kyc = IStoreKYC(_kyc);
    }

    // Freeze any non-force transfers
    function freeze(bool status) external onlyRegulator {
        frozen = status;
    }


    function verifyTransfer(address _from, address _to, uint256 /* _value */, bytes calldata /* _data */) external view returns (byte, bytes32) {
        // regulators are allowed to force things.
        if (isRegulator(msg.sender)) {
            return (hex"11", bytes32(uint256(uint160(msg.sender))));
        }

        // Issuance can be done when the tokens are frozen
        // Issuance conditions 
     
        if (frozen) {
            return (hex"10", bytes32(0x0));
        }

        // transfer checking conditions for non-regulator iniatiated trades
    }

}
