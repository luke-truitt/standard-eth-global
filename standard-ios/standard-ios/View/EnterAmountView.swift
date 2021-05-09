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
    @State var amount: Double = 0.00
    var body: some View {
        VStack{
            Spacer()
            TextField("", value: $amount,formatter: currencyFormatter)
                .keyboardType(.numberPad).textFieldStyle(AmountTextFieldStyle())
            Spacer()
            if(amount == 0.00){
            HStack{
                Button("$1"){}.buttonStyle(RoundedOutlinedButtonStyle())
                Button("$10"){}.buttonStyle(RoundedOutlinedButtonStyle())
                Button("$100"){}.buttonStyle(RoundedOutlinedButtonStyle())
            }}
            else{
                Button("Review"){}.buttonStyle(RoundedFilledButtonStyle())
            }
        }
        .padding(20)
    }
}

struct EnterAmountView_Previews: PreviewProvider {
    static var previews: some View {
        EnterAmountView()
    }
}
