// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PaymentDistribution {
    struct PaymentDistributionParameters {
        uint256 amount;
        address author;
        address reviewer;
        address editor1;
        address editor2;
    }

    address public descierWallet;
    uint256 public platformShare;
    uint256 public authorShare;
    uint256 public reviewerShare;
    uint256 public editorShare;

    constructor(address _descierWallet) {
        descierWallet = _descierWallet;
        platformShare = 20;
        authorShare = 50;
        reviewerShare = 10;
        editorShare = 10;
    }

    function calculateShares(uint256 amount) public view returns (uint256, uint256, uint256, uint256) {
        uint256 totalShares = platformShare + authorShare + reviewerShare + editorShare;

        uint256 platformAmount = (amount * platformShare) / totalShares;
        uint256 authorAmount = (amount * authorShare) / totalShares;
        uint256 reviewerAmount = (amount * reviewerShare) / totalShares;
        uint256 editorAmount = (amount * editorShare) / totalShares;

        return (platformAmount, authorAmount, reviewerAmount, editorAmount);
    }

    function distributePayment(PaymentDistributionParameters memory params) public {
        uint256 platformAmount;
        uint256 authorAmount;
        uint256 reviewerAmount;
        uint256 editorAmount;
        (platformAmount, authorAmount, reviewerAmount, editorAmount) = calculateShares(params.amount);

        payable(descierWallet).transfer(platformAmount);
        payable(params.author).transfer(authorAmount);
        payable(params.reviewer).transfer(reviewerAmount);
        payable(params.editor1).transfer(editorAmount);
        payable(params.editor2).transfer(editorAmount);
    }
}
