pragma solidity ^0.8.0;

import "./IAuthorizer.sol";

interface IAuthorized {

	function setAuthorizer(IAuthorizer _authorizer) external;
}