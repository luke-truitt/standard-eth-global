//
//  InterestRateBody.swift
//  
//
//  Created by Luke Truitt on 5/10/21.
//

import Foundation

final class InterestRateBody: Codable {
    var id: Int?
    var query:String
    
    init(query:String){
        self.query = query
    }
}
