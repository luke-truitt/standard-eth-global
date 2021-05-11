//
//  User.swift
//  
//
//  Created by Work on 5/9/21.
//

import Foundation

class User {
    let id = UUID()
    var accounts : [[String:String]]
    var name : String
    var email : String
    var phone_number: String
    var wallet : Wallet
    
    init(){
        self.accounts = []
        self.name = ""
        self.email = ""
        self.phone_number = ""
        self.wallet = Wallet(userId: id)
    }
}
