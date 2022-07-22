require("@nomiclabs/hardhat-waffle");
require("dotenv").config();


module.exports = {
  solidity: "0.8.9",
  networks: {
    hardhat: {
      chainId: 80001
    },
    mumbai: {
      url: "https://polygon-mumbai.infura.io/v3/50966c137a6b40d988bd8459ae416fca",
      accounts: [process.env.PK]
    },
    // polygon: {
    //   url: "https://polygon-rpc.com/",
    //   accounts: [process.env.pk]
    // }
  }
};
