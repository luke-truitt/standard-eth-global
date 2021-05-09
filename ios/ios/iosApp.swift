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
    let client : EthereumClient! = EthereumClient(url: URL(string: "https://kovan.infura.io/v3/700be78778b349229366a4a40b1d5df2")!, sessionConfig: URLSessionConfiguration.default )
    var body: some Scene {
        WindowGroup {
            ContentView().onAppear(perform: initialize)
        }
    }
    
    func initialize() {
        let userAddress = EthereumAddress("0xb5f62A0473154bb056B8CdBcC9F525B136eB3BbE")
        let userKey = "36cf2b7d4955842eee79b8c2692dc52c086c2d272c533f80973938c9df491b9f"
//        let keyStorage = EthereumKeyLocalStorage()
//        try! keyStorage.storePrivateKey(key: "36cf2b7d4955842eee79b8c2692dc52c086c2d272c533f80973938c9df491b9f".web3.keccak256)
//        var account = try! EthereumAccount(keyStorage: keyStorage)
//        print(account.address)
        var keyStorage = TestEthereumKeyStorage(privateKey: userKey)
        var account = try! EthereumAccount(keyStorage: keyStorage)
        account.address = userAddress
        print(account.publicKey)
        let contractAddress = EthereumAddress("0xE0fBa4Fc209b4948668006B2bE61711b7f465bAe")
        let tokenAddress = EthereumAddress("0xff795577d9ac8bd7d90ee22b6c1703490b6512fd")
        let depositValue = "100000"
        let referralValue = "0"
        let abiUrl = Bundle.main.url(forResource: "LendingPoolABI", withExtension: "json")!
        
        client!.eth_gasPrice(completion: {(error, price) in
            let usePrice = price! * 100
            print(usePrice)
            do {
                let function = Deposit(asset: tokenAddress, amount: 100, onBehalfOf: userAddress, referralCode: 0, gasPrice: usePrice, gasLimit: BigUInt(5000000))
                let transaction = try function.transaction()
                client!.eth_getTransactionCount(address: userAddress, block: .Latest) { error, count in
                    let tx = EthereumTransaction(from: userAddress, to: transaction.to, value: 1, data: transaction.data, nonce: count, gasPrice: transaction.gasPrice, gasLimit: transaction.gasLimit, chainId: 42)
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

public struct Deposit: ABIFunction {
        public static let name = "deposit"
        public let contract: EthereumAddress = EthereumAddress("0xE0fBa4Fc209b4948668006B2bE61711b7f465bAe")
        public let from: EthereumAddress? = nil
        public let asset: EthereumAddress
        public let amount: BigUInt //uint104
        public let onBehalfOf: EthereumAddress
        public let referralCode: UInt16

        public let gasPrice: BigUInt?
        public let gasLimit: BigUInt?
        
        public func encode(to encoder: ABIFunctionEncoder) throws {
            try encoder.encode(asset)
            try encoder.encode(amount, staticSize: 256)
            try encoder.encode(onBehalfOf)
            try encoder.encode(referralCode, staticSize: 16)
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
