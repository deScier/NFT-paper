pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ScientificPaperNFT is ERC721, Ownable {
    struct Paper {
        string ipfsHash;
        address editor;
        address revisor1;
        address revisor2;
        uint256 approvals;
    }

    uint256 public nextPaperId;
    mapping(uint256 => Paper) public papers;

    event PaperSubmitted(uint256 indexed paperId, string ipfsHash);
    event ApprovalReceived(uint256 indexed paperId, address indexed revisor);

    constructor() ERC721("ScientificPaper", "SP") {}

    function submitPaper(string memory ipfsHash, address editor, address revisor1, address revisor2) public onlyOwner {
        papers[nextPaperId] = Paper(ipfsHash, editor, revisor1, revisor2, 0);
        emit PaperSubmitted(nextPaperId, ipfsHash);
        nextPaperId++;
    }

    function approve(uint256 paperId) public {
        Paper storage paper = papers[paperId];

        require(msg.sender == paper.editor || msg.sender == paper.revisor1 || msg.sender == paper.revisor2, "Not authorized");
        require(paper.approvals < 2, "Already approved");

        paper.approvals++;

        emit ApprovalReceived(paperId, msg.sender);

        if (paper.approvals == 2) {
            _mint(owner(), paperId);
        }
    }
}
