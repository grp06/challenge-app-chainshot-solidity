require("@nomiclabs/hardhat-waffle");

// Go to https://www.alchemyapi.io, sign up, create
// a new App in its dashboard, and replace "KEY" with its key
const INFURA_API_KEY = "17e47e3ebcd04158b89c68d9f6f2a8bc";

// Replace this private key with your Goerli account private key
// To export your private key from Metamask, open Metamask and
// go to Account Details > Export Private Key
// Be aware of NEVER putting real Ether into testing accounts
const KOVAN_PRIVATE_KEY = "5f9a26937a48e1d6659c13f2115159886318545a405b33e9658e8188609cd80b";
const LOCAL_PRIVATE_KEY = "0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80"
module.exports = {
  solidity: {
    compilers: [
      {
        version: "0.6.12"
      },
      {
        version: "0.8.0"
      },
    ],
  },
  networks: {
    localhost: {
      chainId: 31337, // Chain ID should match the hardhat network's chainid
      accounts: [`${LOCAL_PRIVATE_KEY}`]
    },    
    kovan: {
      url: `https://kovan.infura.io/v3/${INFURA_API_KEY}`,
      accounts: [`${KOVAN_PRIVATE_KEY}`]
    }
  }
};