const { expect } = require("chai");
const hre = require("hardhat");
const { time } = require("@nomicfoundation/hardhat-network-helpers");

describe("SingleAccountAuthorizer", function () {
  it("Should be authorized upon deploy", async function () {
  	const SingleAccountAuthorizer = await hre.ethers.getContract("SingleAccountAuthorizer");
	const singleAccountAuthorizer = await SingleAccountAuthorizer.deploy();

	const AuthorizedFaucet = await hre.ethers.getContractFactory("AuthorizedFaucet");
	const authorizedFaucet = await AuthorizedFaucet.deploy(singleAccountAuthorizer.address);

  	const fundFaucetTransactionReceipt = await authorizedFaucet.pay({
  		value: "1000000000000000000000000"
  	});

  	expect(await hre.ethers.provider.getBalance(authorizedFaucet.address))
  		.to.eql(hre.ethers.BigNumber.from("1000000000000000000000000"));
    expect(await singleAccountAuthorizer.isAuthorized(SingleAccountAuthorizer.signer.address)).to.equal(true);
  });
});
