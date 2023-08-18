// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "@shambadynamic/contracts/contracts/ShambaGeoConsumer.sol";

contract GeoInsuranceConsumer is ShambaGeoConsumer {
    address payable private insurer;
    address payable public client;
    uint256 public payoutValue;
    int256 public geostatsThreshold;
    bool public isContractActive;
    bool public isContractPaid = false;

    /**
     * @dev Creates a new Insurance contract
     */
    constructor(
        address payable _client,
        uint256 _payoutValue,
        int256 _geostatsThreshold,
        uint256 _chainId
    ) payable ShambaGeoConsumer(_chainId) {
        require(msg.value >= _payoutValue);
        
        geostatsThreshold = _geostatsThreshold;
        insurer = payable(msg.sender);
        client = _client;
        payoutValue = _payoutValue;
        isContractActive = true;
    }

    /**
     * @dev
     * This function will return the current geostats data returned by the getGeostatsData function of the imported ShambaGeoConsumer contract
     */
    function getShambaGeostatsData(address payable _insurer) public {
        require(isContractActive);

        require(
            ShambaGeoConsumer.getLatestGeostatsData() != 0 &&
                ShambaGeoConsumer.getLatestGeostatsData() != -1
        );

        if (ShambaGeoConsumer.getLatestGeostatsData() <= geostatsThreshold) {
            // threshold has been met
            payOutContract();
        } else {
            refundInsurer(_insurer);
        }
    }

    /**
     * @dev Insurance conditions have been met, do payout of total cover amount to client
     */
    function payOutContract() private {
        //Transfer agreed amount to client
        client.transfer(address(this).balance);
        isContractPaid = true;
        isContractActive = false;
    }

    /**
     * @dev Insurance conditions haven't met, refund payout of total cover amount back to the insurer
     */
    function refundInsurer(address payable _insurer) private {
        //Transfer amount back to insurer
        _insurer.transfer(address(this).balance);
        isContractActive = false;
    }
}
