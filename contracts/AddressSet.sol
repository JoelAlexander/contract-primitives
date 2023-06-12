//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract AddressSet {

    event AddressAdded(address indexed by, address indexed added);
    event AddressRemoved(address indexed by, address indexed removed);

    address owner;
    mapping(address => uint) indicies;
    mapping(uint => bool) present;
    address[] addresses;
    uint public count = 0;

    constructor(address _owner) {
        owner = _owner;
    }

    modifier onlyOwner {
        require(msg.sender == owner || owner == address(0x0));
        _;
    }

    function add(address addr) external onlyOwner {
        require(indicies[addr] == 0, "Address must not already be added");
        uint index = addresses.length + 1;
        indicies[addr] = index;
        present[index] = true;
        addresses.push(addr);
        count++;
        emit AddressAdded(msg.sender, addr);
    }

    function remove(address addr) external onlyOwner {
        require(indicies[addr] != 0, "Address must already be added");
        present[indicies[addr]] = false;
        indicies[addr] = 0;
        count--;
        emit AddressRemoved(msg.sender, addr);
    }

    function contains(address addr) external view returns (bool) {
        return indicies[addr] != 0;
    }

    function contents() external view returns (address[] memory) {
        uint j = 0;
        address[] memory trimmed = new address[](count);
        for (uint i = 0; i < addresses.length; i++) {
            if (present[i + 1]) {
                trimmed[j] = addresses[i];
                j++;
            }
        }

        return trimmed;
    }
}
