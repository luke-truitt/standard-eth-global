//
//  ConfirmAmountView.swift
//  standard-ios
//
//  Created by Work on 5/10/21.
//

import SwiftUI

struct ConfirmAmountView: View {
    @Binding var amount : Double
    var onConfirmPress : () -> ()
    var onCancelPress : () -> ()
    var title : String
    var subtitle : String
    var body: some View {
        VStack{
            Text("Confirm purchase").font(.system(size: 22, weight:.medium))
                .padding(.bottom, 10).padding(.top, 20).multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
            Text("\(subtitle) $\(amount) worth of USDC, worth approximately $\(amount) USD").padding(.bottom, 20)
            Button("Confirm"){onConfirmPress()}.buttonStyle(RoundedFilledButtonStyle())
            Button("Cancel"){onCancelPress()}.buttonStyle(RoundedOutlinedButtonStyle())
            Spacer()
        }.padding(20)
    }
}
