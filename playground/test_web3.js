var Tx = require('ethereumjs-tx').Transaction
var Web3 = require('web3')

var web3 = new Web3('https://kovan.infura.io')

const account1 = '0xb5f62A0473154bb056B8CdBcC9F525B136eB3BbE'
const account2 = '0xCe697A0aF5dA8faB0C13Ba9640488fC8975a3f9B'

const privateKey1 = Buffer.from(process.env.PRIVATE_KEY_1, 'hex')
const privateKey2 = Buffer.from(process.env.PRIVATE_KEY_2, 'hex')

web3.eth.getBalance(account1, (err, bal) => {
    console.log('act1', web3.utils.fromWei(bal, 'ether'));
})
web3.eth.getBalance(account2, (err, bal) => {
    console.log('act2', web3.utils.fromWei(bal, 'ether'));
})
// console.log(privateKey1)
web3.eth.getTransactionCount(account1, (err, txCount) => {
    const txObject = {
        nonce: web3.utils.toHex(txCount),
        to: account2,
        value: web3.utils.toHex(web3.utils.toWei('0.2', 'ether')),
        gasLimit: web3.utils.toHex(21000),
        gasPrice: web3.utils.toHex(web3.utils.toWei('10', 'gwei'))
    }
    
    const tx = new Tx(txObject, {chain: 'kovan'})
    tx.sign(privateKey1)

    const serializedTx = tx.serialize()
    const raw = '0x' + serializedTx.toString('hex')

    web3.eth.sendSignedTransaction(raw, (err, txHash) => {
        console.log(txHash);
    })
})

