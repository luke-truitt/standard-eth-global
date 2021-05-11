//
//  WalletView.swift
//  standard-ios
//
//  Created by Work on 5/8/21.
//

import SwiftUI


struct WalletView: View {
    var wallet : Wallet
    var switchView : (String) -> ()
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    @State var interest : Float = 0
    let interestRate : Float
    
    var body: some View {
        let coins = wallet.balances_matic.map{$0.key}
        let balances = wallet.balances_matic.map {$0.value}
//        let interest = wallet.getInterestEarned()
        let totalBalance = wallet.getTotalBalance()
        let interestRate = wallet.getInterestRatePerDay()
        let interestFormatted = String(format: "$%.10f", interest)
        
        VStack{
            VStack {
                Text("Earnings").font(.title).frame(maxWidth: .infinity, alignment: .leading).padding(.bottom, 5)
                Text("\(interestFormatted)").frame(maxWidth: .infinity, alignment: .leading).font(.title3)
                    .onReceive(timer) {_ in
                    interest = interest + (interestRate*totalBalance)
                        print("interest updated \(interest)")
                }
                Text("Balance: $\(totalBalance)").frame(maxWidth: .infinity, alignment: .leading)
            }.padding(.bottom, 50)
            VStack {
                Text("Wallet").font(.title).frame(maxWidth: .infinity, alignment: .leading)
                ForEach(coins.indices) {index in
                    HStack{
                        Image("\(coins[index])").resizable().aspectRatio(contentMode: .fill)
                            .frame(width: 30.0, height: 30.0, alignment: .center)
                            .clipShape(Circle())
                        Spacer()
                        Text(coins[index])
                        Spacer()
                        Text("$\(balances[index])")
                    }.padding(.all, 20).background(RoundedRectangle(cornerRadius: 8).strokeBorder(Color.primary.opacity(0.2), lineWidth: 1))
                }
            }
            Spacer()
            VStack {
//                Button("Earn"){}.buttonStyle(RoundedFilledButtonStyle())
                Button("Buy"){switchView("Buy")}.buttonStyle(RoundedFilledButtonStyle())
                Button("Sell"){switchView("Sell")}.buttonStyle(RoundedOutlinedButtonStyle())
            }
        }.padding(.leading, 20).padding(.trailing, 20).padding(.bottom, 20).padding(.top, 40)
        
    }
}

