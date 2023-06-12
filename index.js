const AuthorizedFaucet = require('./artifacts/contracts/AuthorizedFaucet.sol/AuthorizedFaucet.json').abi
const SingleAccountAuthorizer = require('./artifacts/contracts/SingleAccountAuthorizer.sol/SingleAccountAuthorizer.json').abi
const MultiAccountAuthorizer = require('./artifacts/contracts/MultiAccountAuthorizer.sol/MultiAccountAuthorizer.json').abi
const AddressSet = require('./artifacts/contracts/AddressSet.sol/AddressSet.json').abi
const StringSet = require('./artifacts/contracts/StringSet.sol/StringSet.json').abi
const IAuthorizer = require('./artifacts/contracts/IAuthorizer.sol/IAuthorizer.json').abi

module.exports = {
  AuthorizedFaucet,
  SingleAccountAuthorizer,
  MultiAccountAuthorizer,
  AddressSet,
  StringSet,
  IAuthorizer
}
