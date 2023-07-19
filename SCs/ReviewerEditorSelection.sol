// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./UserRegistration.sol";
import "./PaperSubmission.sol";

contract ReviewerEditorSelection {
    struct PaperReviewersEditors {
        address reviewer;
        address[] editors;
    }

    UserRegistration userRegistration;
    PaperSubmission paperSubmission;
    mapping(uint256 => PaperReviewersEditors) public paperReviewersEditors;
    event ReviewerEditorSelected(uint256 indexed paperId, address indexed reviewer, address[] editors);

    constructor(address _userRegistrationAddress, address _paperSubmissionAddress) {
        userRegistration = UserRegistration(_userRegistrationAddress);
        paperSubmission = PaperSubmission(_paperSubmissionAddress);
    }

    function selectReviewerEditor(uint256 _paperId, address _reviewer, address[] memory _editors) public {
        require(userRegistration.isUserRegistered(msg.sender), "User is not registered.");
        require(paperSubmission.getPaper(_paperId).author == msg.sender, "Only the paper author can select reviewer and editors.");
        require(userRegistration.isUserRegistered(_reviewer), "Reviewer must be a registered user.");
        require(_editors.length == 2, "Exactly 2 editors must be selected.");

        for (uint i = 0; i < _editors.length; i++) {
            require(userRegistration.isUserRegistered(_editors[i]), "Editor must be a registered user.");
        }

        paperReviewersEditors[_paperId] = PaperReviewersEditors(_reviewer, _editors);
        emit ReviewerEditorSelected(_paperId, _reviewer, _editors);
    }

    function getReviewerEditor(uint256 _paperId) public view returns (PaperReviewersEditors memory) {
        return paperReviewersEditors[_paperId];
    }
}
