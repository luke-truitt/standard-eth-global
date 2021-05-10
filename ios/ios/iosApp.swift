//
//  iosApp.swift
//  ios
//
//  Created by Work on 5/6/21.
//

//
//  iosApp.swift
//  ios
//
//  Created by Work on 5/6/21.
//
import SwiftUI
import web3
import BigInt


@main
struct iosApp: App {
//    let client : EthereumClient! = EthereumClient(url: URL(string: "https://rpc-mumbai.maticvigil.com/v1/bdf5efccf9de08ad6529de85ac5683ce47f0ffe5")!, sessionConfig: URLSessionConfiguration.default )
    let client : EthereumClient! = EthereumClient(url: URL(string: "https://kovan.infura.io/v3/700be78778b349229366a4a40b1d5df2")!, sessionConfig: URLSessionConfiguration.default )
    var body: some Scene {
        WindowGroup {
   
            ContentView().onAppear(perform: initialize)
        }
    }
    
    func initialize() {
        let userAddress = EthereumAddress("0xb5f62A0473154bb056B8CdBcC9F525B136eB3BbE")
        let user2Address = EthereumAddress("0xCe697A0aF5dA8faB0C13Ba9640488fC8975a3f9B")
        let userKey = "36cf2b7d4955842eee79b8c2692dc52c086c2d272c533f80973938c9df491b9f"
        let contractAddress = EthereumAddress("0xE0fBa4Fc209b4948668006B2bE61711b7f465bAe")
        let tokenAddress = EthereumAddress("0xff795577d9ac8bd7d90ee22b6c1703490b6512fd")
        var keyStorage = TestEthereumKeyStorage(privateKey: userKey)
        var account = try! EthereumAccount(keyStorage: keyStorage)
        account.address = userAddress
        client!.eth_gasPrice(completion: {(error, price) in
            do {
                let function = transfer(contract: tokenAddress, from: userAddress, to: user2Address, value: "300000000000000000000")
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
            
//        client!.eth_gasPrice(completion: {(error, price) in
//            do {
//                client!.eth_getTransactionCount(address: userAddress, block: .Latest) { error, count in
//                    let tx = EthereumTransaction(from: userAddress, to: user2Address, value: 1000000000000000000, data: "0x0".data(using: .utf8), nonce: count, gasPrice: price!, gasLimit: BigUInt(600000), chainId: 42)
//                print(tx)
//                print("big error \(error)")
//                client.eth_sendRawTransaction(tx, withAccount: account) { (bigError, txHash) in
//                    print("error is \(bigError)")
//                    print("TX Hash: \(txHash)")
//
//            }
//        }
//            } catch let transactionError {
//                print(transactionError.localizedDescription)
//            }
            
//            do {
//                let function = Deposit(asset: tokenAddress, amount: BigUInt("295147905179352825856"), onBehalfOf: userAddress, referralCode: UInt16(0), gasPrice: price!, gasLimit: BigUInt(600000))
//                let transaction = try function.transaction()
//                client!.eth_getTransactionCount(address: userAddress, block: .Latest) { error, count in
//                    let tx = EthereumTransaction(from: userAddress, to: transaction.to, value: 0, data: transaction.data, nonce: count, gasPrice: transaction.gasPrice, gasLimit: transaction.gasLimit, chainId: 42)
//                    print(tx)
//                    print("big error \(error)")
//                    client.eth_sendRawTransaction(tx, withAccount: account) { (bigError, txHash) in
//                        print("error is \(bigError)")
//                        print("TX Hash: \(txHash)")
//
//                    }
//                }
//            } catch let transactionError {
//                print(transactionError.localizedDescription)
//            }
            
        })
    }
}

public struct Deposit: ABIFunction {
        public static let name = "deposit"
        public let contract: EthereumAddress = EthereumAddress("0xE0fBa4Fc209b4948668006B2bE61711b7f465bAe")
        public let from: EthereumAddress? = EthereumAddress("0xb5f62A0473154bb056B8CdBcC9F525B136eB3BbE")
    
        public let asset: EthereumAddress
        public let amount: BigUInt //uint104
        public let onBehalfOf: EthereumAddress
        public let referralCode: UInt16

        public let gasPrice: BigUInt?
        public let gasLimit: BigUInt?
        
        public func encode(to encoder: ABIFunctionEncoder) throws {
            try encoder.encode(asset)
            try encoder.encode(amount)
            try encoder.encode(onBehalfOf)
            try encoder.encode(referralCode)
        }
    }

public struct transfer: ABIFunction {
        public static let name = "transfer"
        public let gasPrice: BigUInt? = nil
        public let gasLimit: BigUInt? = nil
        public var contract: EthereumAddress
        public let from: EthereumAddress?

        public let to: EthereumAddress
        public let value: BigUInt

        public init(contract: EthereumAddress,
                    from: EthereumAddress? = nil,
                    to: EthereumAddress,
                    value: BigUInt) {
            self.contract = contract
            self.from = from
            self.to = to
            self.value = value
        }

        public func encode(to encoder: ABIFunctionEncoder) throws {
            try encoder.encode(to)
            try encoder.encode(value)
        }
    }

class TestEthereumKeyStorage: EthereumKeyStorageProtocol {
    private var privateKey: String
    
    init(privateKey: String) {
        self.privateKey = privateKey
    }
    
    func storePrivateKey(key: Data) throws -> Void {
    }
    
    func loadPrivateKey() throws -> Data {
        return privateKey.web3.hexData!
    }
}
