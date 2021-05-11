//
//  WalletEvent.swift
//  
//
//  Created by Work on 5/9/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct WalletEvent: Codable {
    let to : String
    let from : String
    let amount : Float
}
