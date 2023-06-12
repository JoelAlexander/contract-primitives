require("@nomiclabs/hardhat-ethers");
require('hardhat-abi-exporter');

module.exports = {
  "solidity": {
    "version": "0.8.16",
    "settings": {
      "optimizer": {
        "enabled": true,
        "runs": 200,
        "details": {
          "yul": false
        }
      }
    }
  },
  "networks": {
  	"hardhat": {
  	  "accounts": {
	    "accountsBalance": "2000000000000000000000000"
  	  }
	}
  },
  "paths": {
    "sources": "./contracts",
    "cache": "./cache",
    "tests": "./test",
    "artifacts": "./artifacts"
  }
};
