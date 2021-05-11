//
//  Wallet.swift
//  
//
//  Created by Work on 5/9/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


class Wallet : Codable, Identifiable {
    @DocumentID var id: String?
    var userId : String?
    var publicAddress : String
    var privateKey : String
    var balances_matic : [String:Float]
    var history : [WalletEvent]
    @ServerTimestamp var createdTime: Timestamp?
    
    init(userId: String){
        self.balances_matic = ["DAI": 0.00, "USDC":0.00, "TUSD": 0.00]
        self.history = []
        self.userId = userId
        self.publicAddress = ""
        self.privateKey = ""
        //TODO - Initialize wallet and add public, private keys
    }
    
    func getTotalBalance() -> Float {
        return self.balances_matic.map {$0.value}.reduce(0, +)
    }
    
    public func buy(asset:String, amount: Float) {
        let newTotal = ((balances_matic[asset] != nil) ? balances_matic[asset]! : 0) + amount
        self.balances_matic[asset] = newTotal
        //TODO
        let event = WalletEvent(to:publicAddress, from:"STD_ADDRESS", amount:amount)
        history.append(event)

    }
    public func sell(asset:String, amount: Float) {
        let newTotal = ((balances_matic[asset] != nil) ? balances_matic[asset]! : 0)  - amount
        self.balances_matic[asset] = newTotal
        let event = WalletEvent(to:"STD_ADDRESS", from:publicAddress, amount:amount)
        history.append(event)
    }
    
    func getInterestEarned() -> Float{
        //TODO - Calculate interest earned based on wallet events or public chain data
        return 0.00
        
    }
}
