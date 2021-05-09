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
//    @State var user : User = nil
    
    
    var body: some Scene {
  
        WindowGroup {
            if(!onboardComplete){
                OnboardingView(onboardComplete: createUser)
            }
            else {
                WalletView(user: self.user)
            }
        }
        
    }
    
    func createUser(name: String, phone_number: String, email: String){
        self.user.name = name
        self.user.email = email
        self.user.phone_number = phone_number
        print("User Created")
        print(user)
        onboardComplete = true
    }
}

