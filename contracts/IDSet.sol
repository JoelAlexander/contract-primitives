// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract IDSet {

    event IDAdded(address indexed by, uint256 indexed added);
    event IDRemoved(address indexed by, uint256 indexed removed);

    address owner;
    mapping(uint256 => uint) indicies;
    mapping(uint => bool) present;
    uint256[] ids;
    uint public count = 0;

    constructor(address _owner) {
        owner = _owner;
    }

    modifier onlyOwner {
        require(msg.sender == owner || owner == address(0x0));
        _;
    }

    function add(uint256 id) external onlyOwner {
        require(indicies[id] == 0, "ID must not already be added");
        uint index = ids.length + 1;
        indicies[id] = index;
        present[index] = true;
        ids.push(id);
        count++;
        emit IDAdded(msg.sender, id);
    }

    function remove(uint256 id) external onlyOwner {
        require(indicies[id] != 0, "ID must already be added");
        present[indicies[id]] = false;
        indicies[id] = 0;
        count--;
        emit IDRemoved(msg.sender, id);
    }

    function contains(uint256 id) external view returns (bool) {
        return indicies[id] != 0;
    }

    function contents() external view returns (uint256[] memory) {
        uint j = 0;
        uint256[] memory trimmed = new uint256[](count);
        for (uint i = 0; i < ids.length; i++) {
            if (present[i + 1]) {
                trimmed[j] = ids[i];
                j++;
            }
        }

        return trimmed;
    }
}
