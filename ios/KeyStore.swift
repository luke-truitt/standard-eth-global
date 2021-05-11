//
//  KeyStore.swift
//  
//
//  Created by Luke Truitt on 5/11/21.
//

import Foundation

class KeyStore: EthereumKeyStorageProtocol {
    private var privateKey: String
    
    init(privateKey: String) {self.privateKey = privateKey}
    
    func storePrivateKey(key: Data) throws -> Void {
    }
    
    func loadPrivateKey() throws -> Data {
        return privateKey.web3.hexData!
    }
}
