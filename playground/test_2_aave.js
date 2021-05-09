const Web3 = require("web3");
const Tx = require("ethereumjs-tx");
const Config = require("./config.json");
const Util = require("./utils");
const Constants = require("./constants");

const account = {
  address: Config.address,
  privateKey: Config.privateKey,
}
const token = '0xFf795577d9AC8bD7D90Ee22b6C1703490b6512FD'
const ledingContract = '0xE0fBa4Fc209b4948668006B2bE61711b7f465bAe'
const chain = 'kovan'
const value = '0x100000000000000000'

const web3 = new Web3(
  new Web3.providers.HttpProvider(
    `https://${chain}.infura.io/v3/${Config.infuraKey}`
  )
);

const lendingPoolAbi = Util.getABI(Constants.AAVE.LendingPool[chain], chain);
const lendingPoolAddress = Constants.AAVE.LendingPool[chain]


const contract = new web3.eth.Contract(lendingPoolAbi, lendingPoolAddress);


const contractCall = contract.methods.deposit(
   token,
   value,
   onBehalfOf,
   "0x0"
 );

 const estimatedGas = await contractCall.estimateGas({
   from: account.address,
 });
 const txCount = await web3.eth.getTransactionCount(from);
 const gasPrice = await web3.eth.getGasPrice();
 const tx = {
   from: account.address,
   to: Constants.AAVE.LendingPool[chain],
   data: contractCall.encodeABI(),
   value: "0x0",
   nonce: web3.utils.toHex(txCount),
   gasPrice: web3.utils.toHex(gasPrice),
   gasLimit: web3.utils.toHex(Math.ceil(estimatedGas * 1.1)),
 };
 const tx = await buildTransaction({
   web3,
   from: ,
   to: ,
   value: "0x0",
   data: ,
   estimatedGas,
 });

 const signedTx = await signTransaction(tx, account.privateKey, chain);
 const res = await web3.eth.sendSignedTransaction(signedTx);
function sleep(ms) {
  return new Promise((resolve) => {
    setTimeout(resolve, ms);
  });
}

async function signTransaction(raxTx, privateKey, chain) {
  let tx = new Tx.Transaction(raxTx, { chain });
  const prKey = Buffer.from(privateKey, "hex");
  tx.sign(prKey);
  const serializedTx = tx.serialize().toString("hex");
  const signedTx = "0x" + serializedTx;

  return signedTx;
}

async function approveAndDeposit(
  account,
  token,
  spender,
  value,
  chain = Constants.DEFAULT_CHAIN
) {
  const approveTx = await approveToken(account, token, spender, value, chain);

  await sleep(1000);

  const depositTx = await depositToken(
    account,
    token,
    account.address,
    value,
    chain
  );

  return {
    approveTxHash: approveTx.transactionHash,
    depositTxHash: depositTx.transactionHash,
  };
}
async function approveToken(
  account,
  token,
  spender,
  value,
  chain = Constants.DEFAULT_CHAIN
) {
  const web3 = createWeb3(chain);
  let abi;

  if (!web3.utils.isAddress(token)) throw `Approve: invalid token address`;
  if (!Constants.CHAINS.includes(chain)) throw `Approve: not supported chain`;
  if (!(abi = Util.getABI(token, chain)))
    throw `Approve: abi not existing for ${token} in ${chain}`;
  if (!web3.utils.isAddress(account.address))
    throw `Approve: invalid account address - ${account.address}`;
  if (!web3.utils.isAddress(spender))
    throw `Approve: invalid spender address - ${spender}`;

  const contract = getContract(web3, abi, token);
  const contractCall = contract.methods.approve(spender, value);
  const estimatedGas = await contractCall.estimateGas({
    from: account.address,
  });
  const tx = await buildTransaction({
    web3,
    from: account.address,
    to: token,
    value: "0x0",
    data: contractCall.encodeABI(),
    estimatedGas,
  });
  const signedTx = await signTransaction(tx, account.privateKey, chain);
  const res = await web3.eth.sendSignedTransaction(signedTx);

  return res;
}

approveAndDeposit(account, token, ledingContract, value, chain).then(res => {
  console.log(res)
}).catch(err => {
  console.log(err)
})