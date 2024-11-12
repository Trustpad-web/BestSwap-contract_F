// const dotenv = require("dotenv");
// dotenv.config();

// console.log(
//   "=========== SEPOLIA_PRIVATE_KEY ===============>",
//   process.env.INFURA_API_KEY,
//   process.env.SEPOLIA_PRIVATE_KEY
// );
// require("hardhat-deploy");

require("@nomicfoundation/hardhat-toolbox");

const { vars } = require("hardhat/config");
const INFURA_API_KEY = "cbbd92cf67f5425c9510770ab8afa8a9";

const SEPOLIA_PRIVATE_KEY =
  "750a18b0c0e9708ea1a548d07e015191934d5bc7bda015f97c72259f1eb7f166";

module.exports = {
  solidity: {
    compilers: [
      {
        version: "0.5.16",
      },
      {
        version: "0.8.27",
      },
    ],
  },
  networks: {
    sepolia: {
      url: "https://1rpc.io/sepolia",
      accounts: [SEPOLIA_PRIVATE_KEY],
    },
  },
  ignition: {
    requiredConfirmations: 1,
  },
  etherscan: {
    apiKey: {
      sepolia: "5CRMC8PJZRU723K23YWKRPVKYQU7SQJ24J",
    },
  },
};
