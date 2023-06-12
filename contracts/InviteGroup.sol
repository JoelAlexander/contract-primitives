//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./AddressSet.sol";

contract InviteGroup {

	uint public constant MAX_INVITATIONS = 3;

	event InvitationSent(address to, address from);
	event InvitationAccepted(address to, address from);
	event InvitationDeclined(address to, address from);
	event InvitationCanceled(address to, address from);
	event MemberLeft(address addr);

	mapping(address => address) invitations;
	mapping(address => address[MAX_INVITATIONS]) pendingInvitations;
	AddressSet addressSet;

	constructor(address member) {
		addressSet = new AddressSet(address(this));
		addressSet.add(member);
	}

	function invite(address to) external {
		require(addressSet.contains(msg.sender));
		require(!addressSet.contains(to));
		require(invitations[to] == address(0));
		invitations[to] = msg.sender;
		uint i;
		for (i = 0; i < MAX_INVITATIONS; i++) {
			if (pendingInvitations[msg.sender][i] == address(0)) {
				pendingInvitations[msg.sender][i] = to;
				break;
			}
		}
		require(i < MAX_INVITATIONS);
		emit InvitationSent(to, msg.sender);
	}

	function accept() external {
		address from = invitations[msg.sender];
		clearInvitation(msg.sender);
		addressSet.add(msg.sender);
		emit InvitationAccepted(msg.sender, from);
	}

	function decline() external {
		address from = invitations[msg.sender];
		clearInvitation(msg.sender);
		emit InvitationDeclined(msg.sender, from);
	}

	function cancel(address to) external {
		require(invitations[to] == msg.sender);
		clearInvitation(to);
		emit InvitationCanceled(to, msg.sender);
	}

	function clearInvitation(address to) private {
		address from = invitations[to];
		require(from != address(0));
		invitations[to] = address(0);
		uint i;
		for (i = 0; i < MAX_INVITATIONS; i++) {
			if (pendingInvitations[from][i] == to) {
				pendingInvitations[from][i] = address(0);
				break;
			}
		}
		require(i < MAX_INVITATIONS);
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

	function getInvitation(address to) external view returns (address) {
		return invitations[to];
	}

	function getPendingInvitations(address from) external view returns (address[MAX_INVITATIONS] memory) {
		return pendingInvitations[from];
	}
}
