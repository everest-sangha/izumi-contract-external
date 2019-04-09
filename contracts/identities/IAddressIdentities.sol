pragma solidity ^0.5.2;

interface IAddressIdentities {

    function getInvestor(address addr) external view returns (bytes32);
    function putInvestor(address addr, bytes32 id) external;
    function removeInvestor(address addr) external;
    
    event ChangedInvestor(address indexed addr, bytes32 indexed id);

}
