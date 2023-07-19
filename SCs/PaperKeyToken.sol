// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract PaperKeyToken is ERC20 {
    constructor() ERC20("PaperKeyToken", "PKT") {}

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}
