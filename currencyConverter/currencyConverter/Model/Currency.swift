//
//  Currency.swift
//  currencyConverter
//
//  Created by Nicks Villanueva on 10/11/22.
//

import Foundation
struct Currency: Codable {
    let currencyCode, currencyIcon, currencySymbol, currencyDescription: String

    enum CodingKeys: String, CodingKey {
        case currencyCode = "currency_code"
        case currencyIcon = "currency_icon"
        case currencySymbol = "currency_symbol"
        case currencyDescription = "currency_description"
    }
}
