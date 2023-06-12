pragma solidity ^0.8.0;

interface IAuthorizer {

	function isAuthorized(address addr) external view returns (bool);
}
