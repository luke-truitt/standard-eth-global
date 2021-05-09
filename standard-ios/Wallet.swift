//
//  Wallet.swift
//  
//
//  Created by Work on 5/9/21.
//

import Foundation

struct Wallet {
    var userId : UUID
    var publicAddress : String
    var privateKey : String
    var balances_matic : [String:Float]
    var history : [WalletEvent]
    
    init(userId: UUID){
        self.balances_matic = ["DAI": 0.00, "USDC":0.00, "TUSD": 0.00]
        self.history = []
        self.userId = userId
        self.publicAddress = ""
        self.privateKey = ""
        // ADD CODE TO GENERATE PRIVATE AND PUBLIC KEYS
    }
}
