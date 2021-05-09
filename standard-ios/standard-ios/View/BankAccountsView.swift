//
//  BankAccountView.swift
//  standard-ios
//
//  Created by Work on 5/8/21.
//

import SwiftUI

struct BankAccountView: View {
    @State var isChecked:Bool = true
    var accounts : [[String:String]] = [["nickname": "Capital One", "type":"Checking", "digits": "2320"], ["nickname": "CHECKING", "type":"Checking", "digits": "8155"]]
    var body: some View {
        HStack{
            VStack{
                Text(accounts[0]["nickname"]!)
                Text("\(accounts[0]["type"]!) ****\(accounts[0]["digits"]!)").font(.caption2)
        }
            Image(isChecked ? "checkmark.circle": "circle").foregroundColor(.accentColor)

        }
    }
}

struct BankAccountView_Previews: PreviewProvider {
    static var previews: some View {
        BankAccountView()
    }
}
