/** @type import('hardhat/config').HardhatUserConfig */
require("@nomicfoundation/hardhat-toolbox");
module.exports = {
  defaultNetwork: "ganache",
  networks: {
    ganache: {
      url: "http://127.0.0.1:8545",
      // accounts: [privateKey1, privateKey2, ...]
    }
  },
  solidity: "0.8.9",
};
