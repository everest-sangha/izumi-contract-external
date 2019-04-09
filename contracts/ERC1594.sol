pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "./checks/TransferChecker.sol";
import "./issuance/TokenIssuance.sol";
import "./transfers/CheckedTransfers.sol";
import "./redemption/TokenRedemption.sol";
import "./checks/TransferCheckerAppointed.sol";

contract ERC1594 is ERC20, TransferChecker, TransferCheckerAppointed, CheckedTransfers, TokenIssuance, TokenRedemption {

    constructor (uint256 cap) TokenIssuance(cap) public {
    }

}
