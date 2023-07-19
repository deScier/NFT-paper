// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./UserRegistration.sol";

contract PaperSubmission {
    enum Field { Physics, Biology, Chemistry, ComputerScience, SocialScience }

    struct Paper {
        uint256 id;
        address author;
        string title;
        string paperAbstract;
        Field field;
        string contentURI;
    }

    UserRegistration userRegistration;
    uint256 public paperCount = 0;
    mapping(uint256 => Paper) public papers;
    event PaperSubmitted(uint256 indexed paperId, address indexed author);

    constructor(address _userRegistrationAddress) {
        userRegistration = UserRegistration(_userRegistrationAddress);
    }

    event DebugSenderAddress(address indexed sender);

function submitPaper(
    string memory _title,
    string memory _paperAbstract,
    Field _field,
    string memory _contentURI
) public {
    emit DebugSenderAddress(msg.sender);
    require(userRegistration.isUserRegistered(msg.sender), "User is not registered.");
    
        paperCount++;
        papers[paperCount] = Paper(paperCount, msg.sender, _title, _paperAbstract, _field, _contentURI);
        emit PaperSubmitted(paperCount, msg.sender);
    }

    function getPaper(uint256 _paperId) public view returns (Paper memory) {
        return papers[_paperId];
    }
}
