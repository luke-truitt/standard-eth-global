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
    let client : EthereumClient! = EthereumClient(url: URL(string: "https://rpc-mumbai.maticvigil.com/v1/bdf5efccf9de08ad6529de85ac5683ce47f0ffe5")!, sessionConfig: URLSessionConfiguration.default )
    
    var body: some Scene {
        WindowGroup {
   
            ContentView().onAppear(perform: initialize)
        }
    }
    
    func initialize() {
        let url1 = "https://ropsten.infura.io/v3/04a2e2b81e1d48fe9a1957f7ed4d57a5"
  
        let keyStorage = EthereumKeyLocalStorage()
        let account = try? EthereumAccount.create(keyStorage: keyStorage, keystorePassword: "66483287c06b85d31f4f523ae3ff42788b25b6a5c162461b957a8d1dc4f53d87")

        print("\(String(describing: client!.session))");
        print("\(String(describing: client!.network))");
client?.eth_gasPrice(completion: { (error, currentPrice) in
print(error)
            print("The current gas price is \(String(describing: currentPrice))")
        })
        client?.eth_blockNumber(completion: { (error, block) in
            print(error?.localizedDescription)
            print("The current block no  is \(String(describing: block))")
        })
    }
}

