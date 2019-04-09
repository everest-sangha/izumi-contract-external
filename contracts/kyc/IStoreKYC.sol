pragma solidity ^0.5.2;

interface IStoreKYC {

    struct KYCData {
        // initial two data fields for basic implementation
        uint32 countryCode;
        bool accredited;
    }

    function getKYC(bytes32 id) external view returns  (uint32 countryCode, bool accredited);
    function putKYC(bytes32 id, uint32 countryCode, bool accredited) external;
    function removeKYC(bytes32 id) external;

    event ChangedKYC(bytes32 indexed id);

}
