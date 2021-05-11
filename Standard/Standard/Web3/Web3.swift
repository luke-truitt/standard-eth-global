//
//  Web3.swift
//  Standard
//
//  Created by Luke Truitt on 5/11/21.
//

import Foundation

public class Web3 {
    var client:Ethereum
    
    public init(chain:String) {
        self.client = EthereumClient(url: URL(string: "https://kovan.infura.io/v3/700be78778b349229366a4a40b1d5df2")!, sessionConfig: URLSessionConfiguration.default )
    }
    
    public func createAccount(completion: @escaping(EthereumAccount, Error)->Void) {
        
    }
    
    public func loadAccount(address:String, privateKey:String, completion: @escaping(EthereumAccount, Error)->Void) {
        var keyStorage = TestEthereumKeyStorage(privateKey: userKey)
        var account = try! EthereumAccount(keyStorage: keyStorage)
    }
    
    public func transfer(token: String, fromAddress: String, fromKey: String, to: String, amount: String, completion: @escaping(String, Error)->Void) {
        let tokenAddress = EthereumAddress(token)
        let fromAccount = loadAccount(fromAddress, fromKey)
        let toAdd = EthereumAddress(to)
        
        client!.eth_gasPrice(completion: {(error, price) in
        if token == nil {
            // Ethereum Transfer
            do {
                client!.eth_getTransactionCount(address: fromAccount.address, block: .Latest) { error, count in
                    let tx = EthereumTransaction(from: fromAccount.address, to: toAdd, value: amount, data: "0x0".data(using: .utf8), nonce: count, gasPrice: price!, gasLimit: BigUInt(600000), chainId: 42)
                print(tx)
                print("big error \(error)")
                client.eth_sendRawTransaction(tx, withAccount: fromAccount) { (bigError, txHash) in
                    print("error is \(bigError)")
                    print("TX Hash: \(txHash)")

                }
            }
            } catch let transactionError {
                print(transactionError.localizedDescription)
            }
        } else {
            // normal coin
            do {
                let function = transfer(contract: token, from: from.address, to: to, value: amount)
                let transaction = try function.transaction()
                client!.eth_getTransactionCount(address: userAddress, block: .Latest) { error, count in
                    let tx = EthereumTransaction(from: transaction.from, to: transaction.to, value: 0, data: transaction.data, nonce: count, gasPrice: price!, gasLimit: BigUInt(600000), chainId: 42)
                print(tx)
                print("big error \(error)")
                client.eth_sendRawTransaction(tx, withAccount: account) { (bigError, txHash) in
                    print("error is \(bigError)")
                    print("TX Hash: \(txHash)")
    
                    }
                }
                } catch let transactionError {
                    print(transactionError.localizedDescription)
                }
        }
        })
        }
    }
    
    public func deposit(account: EthereumAccount, token:EthereumAddress, amount:String, completion: @escaping(String, Error)->Void) {
        client!.eth_gasPrice(completion: {(error, price) in
            do {
                let function = Deposit(asset: token, amount: amount, onBehalfOf: account.address, referralCode: UInt16(0), gasPrice: price!, gasLimit: BigUInt(600000))
                let transaction = try function.transaction()
                client!.eth_getTransactionCount(address: account.address, block: .Latest) { error, count in
                    let tx = EthereumTransaction(from: account.address, to: transaction.to, value: 0, data: transaction.data, nonce: count, gasPrice: transaction.gasPrice, gasLimit: transaction.gasLimit, chainId: 42)
                    print(tx)
                    print("big error \(error)")
                    client.eth_sendRawTransaction(tx, withAccount: account) { (bigError, txHash) in
                        print("error is \(bigError)")
                        print("TX Hash: \(txHash)")
                        
                    }
                }
            } catch let transactionError {
                print(transactionError.localizedDescription)
            }
        })
    }
    
    public func withdraw(account: EthereumAccount, token:EthereumAddress, amount:String, completion: @escaping(String, Error)->Void) {
        client!.eth_gasPrice(completion: {(error, price) in
            do {
                let function = Withdraw(asset: token, amount: amount, to: account.address, gasPrice: price!, gasLimit: BigUInt(600000))
                let transaction = try function.transaction()
                client!.eth_getTransactionCount(address: account.address, block: .Latest) { error, count in
                    let tx = EthereumTransaction(from: account.address, to: transaction.to, value: 0, data: transaction.data, nonce: count, gasPrice: transaction.gasPrice, gasLimit: transaction.gasLimit, chainId: 42)
                    print(tx)
                    print("big error \(error)")
                    client.eth_sendRawTransaction(tx, withAccount: account) { (bigError, txHash) in
                        print("error is \(bigError)")
                        print("TX Hash: \(txHash)")
                    }
                }
                } catch let transactionError {
                    print(transactionError.localizedDescription)
                }
        })
    }
}
