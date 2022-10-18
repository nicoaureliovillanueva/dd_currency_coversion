//
//  Balance.swift
//  currencyConverter
//
//  Created by Nicks Villanueva on 10/14/22.
//

import Foundation
struct Balance: Codable {
    let userID: String
    let userBalance: [UserCurrencyBalance]

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case userBalance = "user_balance"
    }
}

// MARK: - UserCurrencyBalance
struct UserCurrencyBalance: Codable {
    let code: String
    let balance: Double
    let currencySymbol: String
    
    enum CodingKeys: String, CodingKey {
        case code, balance
        case currencySymbol = "currency_symbol"
    }
}

