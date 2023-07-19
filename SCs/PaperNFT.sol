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
import "./PaperNFTLogic.sol";

contract PaperNFT is ERC721URIStorage, PaperNFTLogic {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    PaymentDistribution public paymentDistribution;
    PaperKeyToken public paperKeyToken;
    uint256 public paperKeyPrice;
    address public descierWallet;

    constructor(
        address _userRegistrationAddress,
        address _paperSubmissionAddress,
        address _reviewerEditorSelectionAddress,
        address _reviewEditingProcessAddress,
        address _publicationDecisionAddress,
        address _descierWallet,
        address _paperKeyTokenAddress,
        address _paymentDistributionAddress,
        uint256 _paperKeyPrice
    )
        ERC721("DescierPaper", "DSCP")
        PaperNFTLogic(
            _userRegistrationAddress,
            _paperSubmissionAddress,
            _reviewerEditorSelectionAddress,
            _reviewEditingProcessAddress,
            _publicationDecisionAddress
        )
    {
        paperKeyToken = PaperKeyToken(_paperKeyTokenAddress);
        paperKeyPrice = _paperKeyPrice;
        descierWallet = _descierWallet;
        paymentDistribution = PaymentDistribution(_paymentDistributionAddress);
    }

    function createPaperNFT(uint256 _paperId) public {
        require(userRegistration.isUserRegistered(msg.sender), "User is not registered.");
        require(paperSubmission.getPaper(_paperId).author != address(0), "Paper does not exist.");
        require(publicationDecision.getPublicationStatus(_paperId).isPublished, "Paper is not published.");

        PaperSubmission.Paper memory paper = paperSubmission.getPaper(_paperId);
        ReviewerEditorSelection.PaperReviewersEditors memory reviewersEditors = reviewerEditorSelection.getReviewerEditor(_paperId);

        _tokenIdCounter.increment();
        uint256 newTokenId = _tokenIdCounter.current();

        // Mint the NFT to the author's address
        _mint(paper.author, newTokenId);

        // Set token URI with paper details
        string memory tokenURI = _generateTokenURI(paper, reviewersEditors);
        _setTokenURI(newTokenId, tokenURI);
    }

     function _generateTokenURI(PaperSubmission.Paper memory paper, ReviewerEditorSelection.PaperReviewersEditors memory reviewersEditors) private pure returns (string memory) {
        string memory uri = string(abi.encodePacked(
            'data:application/json,{"name":"',
            paper.title,
            '","description":"',
            paper.paperAbstract,
            '","author":"',
            toString(paper.author),
            '","reviewer":"',
            toString(reviewersEditors.reviewer),
            '","editors":["',
        toString(reviewersEditors.editors[0]),
            '","',
            toString(reviewersEditors.editors[1]),
            '"]}'
        ));
        return uri;
    }

    function toString(address account) private pure returns (string memory) {
        bytes32 value = bytes32(uint256(uint160(account)));
        bytes memory alphabet = "0123456789abcdef";

        bytes memory str = new bytes(42);
        str[0] = "0";
        str[1] = "x";
        for (uint256 i = 0; i < 20; i++) {
            str[2 + i * 2] = alphabet[uint8(value[i + 12] >> 4)];
            str[3 + i * 2] = alphabet[uint8(value[i + 12] & 0x0f)];
        }
        return string(str);
    }

 function buyPaperKey(uint256 _paperId) public payable {
    require(publicationDecision.getPublicationStatus(_paperId).isPublished, "Paper is not published.");
    require(msg.value == paperKeyPrice, "Incorrect payment amount.");

    {
        (PaperSubmission.Paper memory paper, ReviewerEditorSelection.PaperReviewersEditors memory reviewersEditors) = getPaperDetails(_paperId);

        // Create the struct with the required parameters
        PaymentDistribution.PaymentDistributionParameters memory params = PaymentDistribution.PaymentDistributionParameters({
            amount: msg.value,
            author: paper.author,
            reviewer: reviewersEditors.reviewer,
            editor1: reviewersEditors.editors[0],
            editor2: reviewersEditors.editors[1]
        });

        // Call the distributePayment function with the struct
        paymentDistribution.distributePayment(params);
    }

    // Call the new functions
    mintPaperKeyToken();
}

    // Add the following function to split the logic and reduce local variables
function mintPaperKeyToken() private {
    paperKeyToken.mint(msg.sender, 1);
}

    function getPaperDetails(uint256 _paperId) internal override view returns (PaperSubmission.Paper memory, ReviewerEditorSelection.PaperReviewersEditors memory) {
        return super.getPaperDetails(_paperId);
    }
}