const Web3 = require("web3");
const web3 = new Web3("https://rpc-mumbai.matic.today");
const { ethers } = require("ethers");
import Matic from "maticjs";

const matic = new Matic(options);

const Wallet = ethers.Wallet;
const utils = ethers.utils;
const mnemonic =
  "announce room limb pattern dry unit scale effort smooth jazz weasel alcohol";
wallet = Wallet.fromMnemonic(mnemonic);

const recipient = '"0x8ba1f109551bD432803012645Ac136ddd64DBA72"';
const token = config.MUMBAI_ERC20; // test token address
// const token = config.MUMBAI_WETH
const amount = "1000000000000000000"; // amount in wei

// matic.initialize().then(() => {
//   matic.setWallet(wallet.privateKey);
//   // Transfer ERC20 Tokens
//   matic
//     .transferERC20Tokens(token, recipient, amount, {
//       from,
//     })
//     .then((res) => {
//       console.log("hash", res.transactionHash);
//     });
// });

console.log(wallet.address);
console.log(wallet.privateKey);
// // true
const provider = new ethers.providers.JsonRpcProvider(
  "https://rpc-mumbai.maticvigil.com/",
  {
    name: "Matic Testnet",
    chainId: 80001,
  }
);
tx = {
  to: wallet.address,
  value: utils.parseEther("1.0"),
};

// const wallet.signTransaction(tx)
// const connectedWallet = wallet.connect(provider);
// connectedWallet.getBalance().then((promise) => {
//   console.log(promise);
// });

// .then((promise) => {
//   console.log(promise);
//   const connectedWallet = wallet.connect(provider);
//   connectedWallet.getBalance().then((promise) => {
//     console.log(promise);
//   });
// });

function createWallet(mnemoic) {
  return Wallet.fromMnemonic(mnemonic);
}
