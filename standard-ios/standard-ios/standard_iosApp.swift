//
//  standard_iosApp.swift
//  standard-ios
//
//  Created by Work on 5/8/21.
//

import SwiftUI


@main
struct standard_iosApp: App {
    @State var user: User = User()
    @State var onboardComplete : Bool = false;
    @State var current = "Wallet" // TODO - Switch to enum
    
    
    var body: some Scene {
  
        WindowGroup {
            if(!onboardComplete){
                OnboardingView(onboardComplete: createUser)
            }
            else {
                switch current {
                case "Wallet":
                    WalletView(wallet: self.user.wallet, switchView: switchView)
                case "Buy":
                    BuyView(switchView: switchView, wallet: self.user.wallet)
                case "Sell":
                    SellView(switchView: switchView, wallet: self.user.wallet)
                default:
                    WalletView(wallet: self.user.wallet, switchView: switchView)
                }
            }
        }
        
    }
    
    func createUser(name: String, phone_number: String, email: String){
        self.user.name = name
        self.user.email = email
        self.user.phone_number = phone_number
        onboardComplete = true
    }
    
    func switchView(newView: String){
        current = newView
    }
}

