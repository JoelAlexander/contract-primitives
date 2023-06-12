pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import "./IAuthorized.sol";
import "./IAuthorizer.sol";

contract SingleAccountAuthorizer is IAuthorizer, ERC165 {

	address public owner;

	constructor() {
		owner = msg.sender;
	}

	modifier only_owner {
		require(msg.sender == owner);
		_;
	}

	function isAuthorized(address addr) external override view returns (bool) {
		return owner == addr;
	}

	function setAuthorizer(IAuthorized authorized, IAuthorizer authorizer) external only_owner {
		authorized.setAuthorizer(authorizer);
	}

	function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
		return interfaceId == type(IAuthorizer).interfaceId || super.supportsInterface(interfaceId);
	}
}
