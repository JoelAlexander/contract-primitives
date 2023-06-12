//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./AddressSet.sol";

contract OpenGroup {

	event MemberJoined(address addr);
	event MemberLeft(address addr);

	AddressSet addressSet;

	constructor() {
		addressSet = new AddressSet(address(this));
	}

	function join() external {
		addressSet.add(msg.sender);
		emit MemberJoined(msg.sender);
	}

	function leave() external {
		addressSet.remove(msg.sender);
		emit MemberLeft(msg.sender);
	}

	function isMember(address addr) external view returns (bool) {
		return addressSet.contains(addr);
	}

	function members() external view returns (address[] memory) {
		return addressSet.contents();
	}
}
