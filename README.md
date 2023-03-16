# Scientific Paper NFT 📚

This repository contains a Solidity smart contract for creating and managing non-fungible tokens (NFTs) representing scientific papers. The contract is built using the Ethereum blockchain and leverages the OpenZeppelin ERC721 and Ownable contracts to ensure a secure and standard-compliant implementation.

## 🌟 Features

- Utilizes IPFS for decentralized storage of scientific papers.
- Enables submission, review, and approval of scientific papers in a decentralized manner.
- Mints unique NFTs for each approved paper.
- Utilizes OpenZeppelin ERC721 and Ownable contracts for secure implementation.

## 📜 Contract Overview

The `ScientificPaperNFT` contract defines a `Paper` struct that holds essential details, such as:

- IPFS hash for decentralized paper storage
- Editor's Ethereum address
- Two revisor Ethereum addresses
- Counter for tracking received approvals

The contract allows the contract owner to submit a new paper, which creates a new `Paper` struct and emits a `PaperSubmitted` event. Revisors or the editor can approve a paper, and once a paper receives two approvals, an NFT is minted for that paper. The contract uses events to track and notify users about paper submissions and approvals.

## 🚀 Getting Started

### Prerequisites

- [Node.js](https://nodejs.org/) installed (version 12 or later)
- [Truffle](https://www.trufflesuite.com/) installed for development and testing

### Installation

1. Clone the repository:

```bash

git clone https://github.com/yourusername/scientific-paper-nft.git

```

2. Change to the repository's directory:

```bash

cd scientific-paper-nft

```

3. Install the required dependencies:

```bash

npm install

```

### Deployment

1. Configure your Ethereum network of choice in the truffle-config.js file.
2. Deploy the contract using Truffle:

truffle migrate --network <your_network>

### Testing
Run the tests using Truffle:

```bash

truffle test

```

### 📄 License
This project is licensed under the MIT License - see the LICENSE file for details.
