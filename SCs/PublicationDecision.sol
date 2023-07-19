// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./UserRegistration.sol";
import "./PaperSubmission.sol";
import "./ReviewerEditorSelection.sol";
import "./ReviewEditingProcess.sol";

contract PublicationDecision {
     struct PublicationStatus {
        bool isPublished;
        uint256 upvoteCount;
    }

    UserRegistration userRegistration;
    PaperSubmission paperSubmission;
    ReviewerEditorSelection reviewerEditorSelection;
    ReviewEditingProcess reviewEditingProcess;
    mapping(uint256 => PublicationStatus) public publicationStatuses;
    event PaperPublished(uint256 indexed paperId);

    constructor(
        address _userRegistrationAddress,
        address _paperSubmissionAddress,
        address _reviewerEditorSelectionAddress,
        address _reviewEditingProcessAddress
    ) {
        userRegistration = UserRegistration(_userRegistrationAddress);
        paperSubmission = PaperSubmission(_paperSubmissionAddress);
        reviewerEditorSelection = ReviewerEditorSelection(_reviewerEditorSelectionAddress);
        reviewEditingProcess = ReviewEditingProcess(_reviewEditingProcessAddress);
    }

    function checkPublicationStatus(uint256 _paperId) public {
        require(userRegistration.isUserRegistered(msg.sender), "User is not registered.");
        require(paperSubmission.getPaper(_paperId).author != address(0), "Paper does not exist.");

        ReviewEditingProcess.ReviewDecision memory reviewDecision = reviewEditingProcess.getReviewDecision(_paperId);
        uint256 upvoteCount = _countUpvotes(reviewDecision);

        if (upvoteCount >= 2 && !publicationStatuses[_paperId].isPublished) {
            publicationStatuses[_paperId] = PublicationStatus(true, upvoteCount);
            emit PaperPublished(_paperId);
        } else {
            publicationStatuses[_paperId].upvoteCount = upvoteCount;
        }
    }

    function _countUpvotes(ReviewEditingProcess.ReviewDecision memory _reviewDecision) private pure returns (uint256) {
        uint256 upvoteCount = 0;

        if (_reviewDecision.reviewerDecision == ReviewEditingProcess.Decision.Upvote) {
            upvoteCount++;
        }

        for (uint256 i = 0; i < _reviewDecision.editorDecisions.length; i++) {
            if (_reviewDecision.editorDecisions[i] == ReviewEditingProcess.Decision.Upvote) {
                upvoteCount++;
            }
        }

        return upvoteCount;
    }

      function getPublicationStatus(uint256 _paperId) public view returns (PublicationStatus memory) {
        return publicationStatuses[_paperId];
    }
}
