// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./UserRegistration.sol";
import "./PaperSubmission.sol";
import "./ReviewerEditorSelection.sol";

contract ReviewEditingProcess {
    enum Decision { None, Upvote, Downvote, RequestChanges }

    struct ReviewDecision {
        Decision reviewerDecision;
        Decision[] editorDecisions;
    }

    UserRegistration userRegistration;
    PaperSubmission paperSubmission;
    ReviewerEditorSelection reviewerEditorSelection;
    mapping(uint256 => ReviewDecision) public reviewDecisions;
    event ReviewDecisionMade(uint256 indexed paperId, address indexed user, Decision decision);

    constructor(
        address _userRegistrationAddress,
        address _paperSubmissionAddress,
        address _reviewerEditorSelectionAddress
    ) {
        userRegistration = UserRegistration(_userRegistrationAddress);
        paperSubmission = PaperSubmission(_paperSubmissionAddress);
        reviewerEditorSelection = ReviewerEditorSelection(_reviewerEditorSelectionAddress);
    }

    function makeReviewDecision(uint256 _paperId, Decision _decision) public {
    require(userRegistration.isUserRegistered(msg.sender), "User is not registered.");
    require(paperSubmission.getPaper(_paperId).author != address(0), "Paper does not exist.");
    require(_decision != Decision.None, "Decision cannot be None.");

    ReviewerEditorSelection.PaperReviewersEditors memory reviewersEditors = reviewerEditorSelection.getReviewerEditor(_paperId);
    require(msg.sender == reviewersEditors.reviewer || _isEditor(msg.sender, reviewersEditors.editors), "User is not a reviewer or editor for this paper.");

    if (msg.sender == reviewersEditors.reviewer) {
        // Initialize the editorDecisions array if it's the reviewer's first decision
        if (reviewDecisions[_paperId].reviewerDecision == Decision.None) {
            reviewDecisions[_paperId].editorDecisions = new Decision[](reviewersEditors.editors.length);
        }
        reviewDecisions[_paperId].reviewerDecision = _decision;
    } else {
        uint256 editorIndex = _getEditorIndex(msg.sender, reviewersEditors.editors);
        reviewDecisions[_paperId].editorDecisions[editorIndex] = _decision;
    }

    emit ReviewDecisionMade(_paperId, msg.sender, _decision);
}

    function getReviewDecision(uint256 _paperId) public view returns (ReviewDecision memory) {
    return reviewDecisions[_paperId];
    }

    function _isEditor(address _user, address[] memory _editors) private pure returns (bool) {
        for (uint256 i = 0; i < _editors.length; i++) {
            if (_user == _editors[i]) {
                return true;
            }
        }
        return false;
    }

    function _getEditorIndex(address _user, address[] memory _editors) private pure returns (uint256) {
        for (uint256 i = 0; i < _editors.length; i++) {
            if (_user == _editors[i]) {
                return i;
            }
        }
        revert("User is not an editor.");
    }
}
