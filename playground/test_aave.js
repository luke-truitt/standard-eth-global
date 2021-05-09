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

function createWeb3(chain) {
  const web3 = new Web3(
    new Web3.providers.HttpProvider(
      `https://${chain}.infura.io/v3/${Config.infuraKey}`
    )
  );
  return web3;
}

function getContract(web3, abi, address) {
  const contract = new web3.eth.Contract(abi, address);
  return contract;
}

function sleep(ms) {
  return new Promise((resolve) => {
    setTimeout(resolve, ms);
  });
}

async function buildTransaction({ web3, from, to, value, data, estimatedGas }) {
  const txCount = await web3.eth.getTransactionCount(from);
  const gasPrice = await web3.eth.getGasPrice();
  const tx = {
    from,
    to,
    data,
    value,
    nonce: web3.utils.toHex(txCount),
    gasPrice: web3.utils.toHex(gasPrice),
    gasLimit: web3.utils.toHex(Math.ceil(estimatedGas * 1.1)),
  };

  return tx;
}

async function signTransaction(raxTx, privateKey, chain) {
  let tx = new Tx.Transaction(raxTx, { chain });
  const prKey = Buffer.from(privateKey, "hex");
  tx.sign(prKey);
  const serializedTx = tx.serialize().toString("hex");
  const signedTx = "0x" + serializedTx;

  return signedTx;
}

async function depositToken(
  account,
  token,
  onBehalfOf,
  value,
  chain = Constants.DEFAULT_CHAIN
) {
  const web3 = createWeb3(chain);

  if (!web3.utils.isAddress(token)) throw `Deposit: invalid token address`;
  if (!Constants.CHAINS.includes(chain)) throw `Deposit: not supported chain`;
  if (!web3.utils.isAddress(account.address))
    throw `Deposit: invalid account address - ${account.address}`;
  if (!web3.utils.isAddress(onBehalfOf))
    throw `Deposit: invalid onBehalfOf address - ${onBehalfOf}`;

  const lendingPoolAbi = Util.getABI(Constants.AAVE.LendingPool[chain], chain);
  const contract = getContract(
    web3,
    lendingPoolAbi,
    Constants.AAVE.LendingPool[chain]
  );
  const contractCall = contract.methods.deposit(
    token,
    value,
    onBehalfOf,
    "0x0"
  );
  const estimatedGas = await contractCall.estimateGas({
    from: account.address,
  });
  const tx = await buildTransaction({
    web3,
    from: account.address,
    to: Constants.AAVE.LendingPool[chain],
    value: "0x0",
    data: contractCall.encodeABI(),
    estimatedGas,
  });
  const signedTx = await signTransaction(tx, account.privateKey, chain);
  const res = await web3.eth.sendSignedTransaction(signedTx);

  return res;
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
// const web3 = createWeb3(chain);

// if (!web3.utils.isAddress(token)) throw `Deposit: invalid token address`;
// if (!Constants.CHAINS.includes(chain)) throw `Deposit: not supported chain`;
// if (!web3.utils.isAddress(account.address))
//   throw `Deposit: invalid account address - ${account.address}`;
// if (!web3.utils.isAddress(onBehalfOf))
//   throw `Deposit: invalid onBehalfOf address - ${onBehalfOf}`;
  
// providerInstance.methods.getLendingPool().call().then((lendingPoolAddress) => {

// const lendingPoolInstance = new web3.eth.Contract(lendingPoolABI, lendingPoolAddress, {from: account});

// const supplyValue = 1000;
// // const privateKey1 = Buffer.from(process.env.PRIVATE_KEY_1, 'hex')
// lendingPoolInstance.methods.deposit("0xFf795577d9AC8bD7D90Ee22b6C1703490b6512FD", supplyValue, account, "0x0").estimateGas({from: account}).then(response => {
//   console.log(response);
// }).catch(err => {
//   console.log("MAJOR", err)
// })
// lendingPoolInstance.methods.deposit("0x6b175474e89094c44da98b954eedeac495271d0f", supplyValue, 0).call().then((response) => {
//   console.log(response)
// })

  // .then(response => {
  //   console.log(response)
  // })
//   web3.eth.getTransactionCount(account1, (err, txCount) => {
//     const txObject = {
//         nonce: web3.utils.toHex(txCount),
//         to: account2,
//         value: web3.utils.toHex(web3.utils.toWei('0.2', 'ether')),
//         gasLimit: web3.utils.toHex(21000),
//         gasPrice: web3.utils.toHex(web3.utils.toWei('10', 'gwei'))
//     }
  
//     const tx = new Tx(txObject, {chain: 'kovan'})
//     tx.sign(privateKey1)

//     const serializedTx = tx.serialize()
//     const raw = '0x' + serializedTx.toString('hex')

//     web3.eth.sendSignedTransaction(raw, (err, txHash) => {
//         console.log(txHash);
//     })
// })
    // .once('transactionHash', (hash) => {
    //     console.log(hash);
    // })
    // .on('confirmation', (number, receipt) => {
    //     console.log(receipt);
    // })
    // .on('error', (error) => {
    //     console.log(error);
    // });

//   lendingPoolInstance.methods.getReserveData("0x6b175474e89094c44da98b954eedeac495271d0f").call().then((reserveData) => {
//   const aTokenAddress = reserveData.aTokenAddress;

//   const aTokenInstance = new web3.eth.Contract(aTokenABI, aTokenAddress);

//   aTokenInstance.methods.redeem(withdrawAmount).send({from: account})
//   .once('transactionHash', (hash) => {
//     // transaction hash
//     console.log(hash);
//   })
//   .on('confirmation', (number, receipt) => {
//     // number of confirmations
//   })
//   .on('error', (error) => {
//     console.log(error);
//   });
// })
// .catch((e) => {
//     throw Error(`Error getting aave reserve data: ${e.message}`)
// });
// })
// .catch((e) => {
//     throw Error(`Error getting lendingPool address: ${e.message}`)
// });


