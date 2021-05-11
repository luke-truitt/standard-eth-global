//
//  Withdraw.swift
//  Standard
//
//  Created by Luke Truitt on 5/11/21.
//

import Foundation

public struct Withdraw: ABIFunction {
        public static let name = "withdraw"
        public let contract: EthereumAddress = EthereumAddress("0xE0fBa4Fc209b4948668006B2bE61711b7f465bAe")
        public let from: EthereumAddress? = EthereumAddress("0xb5f62A0473154bb056B8CdBcC9F525B136eB3BbE")
    
        public let asset: EthereumAddress
        public let amount: BigUInt //uint104
        public let to: EthereumAddress

        public let gasPrice: BigUInt?
        public let gasLimit: BigUInt?
        
        public func encode(to encoder: ABIFunctionEncoder) throws {
            try encoder.encode(asset)
            try encoder.encode(amount)
            try encoder.encode(to)
        }
    }
