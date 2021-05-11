//
//  EnterAmountView.swift
//  standard-ios
//
//  Created by Work on 5/8/21.
//

import SwiftUI

private var currencyFormatter: NumberFormatter = {
    let f = NumberFormatter()
    // allow no currency symbol, extra digits, etc
    f.isLenient = true
    f.numberStyle = .currency
    return f
}()


struct EnterAmountView: View {
    @Binding var amount : Double
    @Binding var showSheetView : Bool

    var body: some View {
        VStack{
            Spacer()
            TextField("", value: $amount,formatter: currencyFormatter)
                .keyboardType(.numberPad).textFieldStyle(AmountTextFieldStyle())
            Spacer()
            if(amount == 0.00){
            HStack{
                Button("$1"){amount=1.00}.buttonStyle(RoundedOutlinedButtonStyle())
                Button("$10"){amount=10.00}.buttonStyle(RoundedOutlinedButtonStyle())
                Button("$100"){amount=100.00}.buttonStyle(RoundedOutlinedButtonStyle())
            }}
            else{
                Button("Review"){
                    self.showSheetView.toggle()
                }.buttonStyle(RoundedFilledButtonStyle())
            }
        }
        .padding(20)
    }
    
}
