//
//  Account.swift
//  
//
//  Created by Luke Truitt on 5/11/21.
//

import Foundation
import web3

public class Account: EthereumAccount {
    private var privateKey: String
    
    init(privateKey: String) {self.privateKey = privateKey}
    
    func storePrivateKey(key: Data) throws -> Void {
    }
    
    func loadPrivateKey() throws -> Data {
        return privateKey.web3.hexData!
    }
}
