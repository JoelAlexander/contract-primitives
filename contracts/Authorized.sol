pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/introspection/ERC165Checker.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import "./IAuthorized.sol";

contract Authorized is IAuthorized, ERC165 {

	IAuthorizer public authorizer;

	constructor(IAuthorizer _authorizer) {
		authorizer = _authorizer;
	}

	modifier only_authorizer {
		require(msg.sender == address(authorizer));
		_;
	}

	modifier only_authorized() {
		require(authorizer.isAuthorized(msg.sender), "Sender must be authorized");
		_;
	}

	function setAuthorizer(IAuthorizer _authorizer) external override only_authorizer {
		require(
			ERC165Checker.supportsInterface(
				address(_authorizer),
				type(IAuthorizer).interfaceId),
			"Must support IAuthorizer interface");
		authorizer = _authorizer;
	}

	function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
 	   return interfaceId == type(IAuthorized).interfaceId || super.supportsInterface(interfaceId);
 	} 
}
