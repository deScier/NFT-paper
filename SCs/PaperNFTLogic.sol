// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./UserRegistration.sol";
import "./PaperSubmission.sol";
import "./ReviewerEditorSelection.sol";
import "./ReviewEditingProcess.sol";
import "./PublicationDecision.sol";
import "./PaperKeyToken.sol";
import "./PaymentDistribution.sol";

contract PaperNFTLogic {
    UserRegistration userRegistration;
    PaperSubmission paperSubmission;
    ReviewerEditorSelection reviewerEditorSelection;
    ReviewEditingProcess reviewEditingProcess;
    PublicationDecision publicationDecision;

    constructor(
        address _userRegistrationAddress,
        address _paperSubmissionAddress,
        address _reviewerEditorSelectionAddress,
        address _reviewEditingProcessAddress,
        address _publicationDecisionAddress
    ) {
        userRegistration = UserRegistration(_userRegistrationAddress);
        paperSubmission = PaperSubmission(_paperSubmissionAddress);
        reviewerEditorSelection = ReviewerEditorSelection(_reviewerEditorSelectionAddress);
        reviewEditingProcess = ReviewEditingProcess(_reviewEditingProcessAddress);
        publicationDecision = PublicationDecision(_publicationDecisionAddress);
    }

     function getPaperDetails(uint256 _paperId) internal virtual view returns (PaperSubmission.Paper memory, ReviewerEditorSelection.PaperReviewersEditors memory) {
        PaperSubmission.Paper memory paper = paperSubmission.getPaper(_paperId);
        ReviewerEditorSelection.PaperReviewersEditors memory reviewersEditors = reviewerEditorSelection.getReviewerEditor(_paperId);

        return (paper, reviewersEditors);
    }
}