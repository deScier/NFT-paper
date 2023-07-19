// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UserRegistration {
    struct User {
        address walletAddress;
        string username;
        bool isRegistered;
    }

    mapping(address => User) public users;
    event UserRegistered(address indexed walletAddress, string username);

    function registerUser(string memory _username) public {
        require(!users[msg.sender].isRegistered, "User is already registered.");
        require(bytes(_username).length > 0, "Username cannot be empty.");

        users[msg.sender] = User(msg.sender, _username, true);
        emit UserRegistered(msg.sender, _username);
    }

    function isUserRegistered(address _userAddress) public view returns (bool) {
        return users[_userAddress].isRegistered;
    }

    function getUsername(address _userAddress) public view returns (string memory) {
        require(users[_userAddress].isRegistered, "User is not registered.");
        return users[_userAddress].username;
    }
}
