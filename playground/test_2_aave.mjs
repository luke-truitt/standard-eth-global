// import { v1, v2 } from '@aave/protocol-js';

// // Fetch poolReservesData from GQL Subscription
// // Fetch rawUserReserves from GQL Subscription
// // Fetch ethPriceUSD from GQL Subscription

// let userAddress = "0x..."
// let poolReservesData = ''
// let rawUserReserves = ''

// let userSummary = v2.formatUserSummaryData(poolReservesData, rawUserReserves, userAddress.toLowerCase(), Math.floor(Date.now() / 1000))
import Tx from 'ethereumjs-tx'
import { TxBuilderV2, Network, Market } from '@aave/protocol-js'
// import { EthereumTransactionTypeExtended } from '@aave/protocol-js'
import Web3 from "web3";
const amount = 1000
const user = '0xb5f62A0473154bb056B8CdBcC9F525B136eB3BbE'
const httpProvider = new Web3.providers.HttpProvider(
      "https://kovan.infura.io/v3/700be78778b349229366a4a40b1d5df2"
  );
const web3 = new Web3(httpProvider);

// const signer = httpProvider.getSigner(user);
const txBuilder = new TxBuilderV2(Network.kovan, httpProvider);

let lendingPool = txBuilder.getLendingPool(Market.Proto); // get all lending pool methods


const privateKey1 = Buffer.from(process.env.PRIVATE_KEY_1, 'hex')

const reserve = '0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa'
let tx = lendingPool.deposit({
    user,
    reserve,
    amount,
 }).then(response => { 
    console.log(response)
    // (reserve, amount, user, 0)
    // .then(res => console.log(res))
    // .catch(err => console.log(err))
    
    // response[0].tx().then(res => {
    //     res.gasLimit = res.gasLimit.toHexString()
    //     console.log(res)
    //     const signPromise = web3.eth.accounts.signTransaction(res, process.env.PRIVATE_KEY_1).then(signedTx => {
    //         const sentTx = web3.eth.sendSignedTransaction(signedTx.raw || signedTx.rawTransaction);
    //         sentTx.on("receipt", receipt => {
    //             // do something when receipt comes back
    //             console.log(receipt)
    //         });
    //         sentTx.on("error", err => {
    //             console.log(err)
    //             // do something on transaction error
    //         });
    //     })
    // })
 }).catch(err => console.log("err", err))