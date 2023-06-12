// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import "./IAuthorized.sol";
import "./IAuthorizer.sol";

contract MultiAccountAuthorizer is IAuthorizer, ERC165 {
    address public owner;
    mapping(address => bool) public authorizedAddresses;

    constructor() {
        owner = msg.sender;
        authorizedAddresses[owner] = true;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    modifier onlyAuthorized {
        require(authorizedAddresses[msg.sender], "Only authorized addresses can perform this action");
        _;
    }

    function isAuthorized(address addr) external view override returns (bool) {
        return authorizedAddresses[addr];
    }

    function addAddress(address addr) external onlyAuthorized {
        authorizedAddresses[addr] = true;
    }

    function removeAddress(address addr) external onlyOwner {
        require(addr != owner, "Owner cannot be removed");
        authorizedAddresses[addr] = false;
    }

    function setAuthorizer(IAuthorized authorized, IAuthorizer authorizer) external onlyOwner {
        authorized.setAuthorizer(authorizer);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IAuthorizer).interfaceId || super.supportsInterface(interfaceId);
    }
}
