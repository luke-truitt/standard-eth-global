//
//  BuyView.swift
//  standard-ios
//
//  Created by Work on 5/9/21.
//

import SwiftUI
import Stripe

struct BuyView: View {
    var switchView : (String) ->()
    @State var wallet : Wallet
    @State var showSheetView : Bool = false
    @State var amount : Double = 0.00
    var body: some View {
        EnterAmountView(amount: $amount, showSheetView: $showSheetView).sheet(isPresented: $showSheetView) {
            ConfirmAmountView(amount: $amount, onConfirmPress: onConfirmPress, onCancelPress: onCancelPress, title: "Confirm purchase", subtitle: "You are purchasing ")
        }
    }
    
    
    func onConfirmPress() {
        //TODO - Correct asset
        wallet.buy(asset:"USDC", amount:  Float(amount))
        switchView("Wallet")
    }
    func onCancelPress() {
        showSheetView.toggle()
    }
}
