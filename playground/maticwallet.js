const Web3 = require("web3");
const web3 = new Web3("https://rpc-mumbai.matic.today");
const { ethers } = require("ethers");
// import Matic from "maticjs";

// const matic = new Matic(options);

const Wallet = ethers.Wallet;
const utils = ethers.utils;
const mnemonic =
  "forest burst jungle inch report alone clock unlock then copy panel come";
const mn1 =
  "agree bacon favorite electric cover whip labor brave cry kitchen rose current";
wallet = Wallet.fromMnemonic(mnemonic);
wallet2 = Wallet.fromMnemonic(mnemonic);
const recipient = wallet2.address;

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

console.log(wallet2.address);
console.log(wallet.privateKey);
// const provider = new ethers.providers.JsonRpcProvider(
//   "https://rpc-mumbai.maticvigil.com/",
//   {
//     name: "Matic Testnet",
//     chainId: 80001,
//   }
// );

// tx = {
//   to: recipient,
//   value: utils.parseEther("1.0"),
// };

// const connectedWallet = wallet.connect(provider);
// connectedWallet
//   .getBalance()
//   .then((promise) => {
//     console.log(promise);
//   })
//   .catch((err) => {
//     console.log(err);
//   });
// wallet.signTransaction(tx).then((promise) => {
//   console.log(promise);
//   const connectedWallet = wallet.connect(provider);
//   connectedWallet.getBalance().then((promise) => {
//     console.log(promise);
//   });
// });

// function createWallet(mnemoic) {
//   return Wallet.fromMnemonic(mnemonic);
// }
