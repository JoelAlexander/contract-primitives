//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract StringSet {

    event StringAdded(address indexed by, string added);
    event StringRemoved(address indexed by, string removed);

    address owner;
    mapping(string => uint) indicies;
    mapping(uint => bool) present;
    string[] strings;
    uint public count = 0;

    constructor(address _owner) {
        owner = _owner;
    }

    modifier onlyOwner {
        require(msg.sender == owner || owner == address(0x0));
        _;
    }

    function add(string memory str) external onlyOwner {
        require(indicies[str] == 0, "String must not already be added");
        uint index = strings.length + 1;
        indicies[str] = index;
        present[index] = true;
        strings.push(str);
        count++;
        emit StringAdded(msg.sender, str);
    }

    function remove(string memory str) external onlyOwner {
        require(indicies[str] != 0, "String must already be added");
        present[indicies[str]] = false;
        indicies[str] = 0;
        count--;
        emit StringRemoved(msg.sender, str);
    }

    function contains(string memory str) external view returns (bool) {
        return indicies[str] != 0;
    }

    function contents() external view returns (string[] memory) {
        uint j = 0;
        string[] memory trimmed = new string[](count);
        for (uint i = 0; i < strings.length; i++) {
            if (present[i + 1]) {
                trimmed[j] = strings[i];
                j++;
            }
        }

        return trimmed;
    }
}
