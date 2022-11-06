// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// First solidity contract
contract simpleStorage {
    uint256 FavoriteNumber;

    function store(uint256 _favoriteNumber) public {
        FavoriteNumber = _favoriteNumber;
    }
}
