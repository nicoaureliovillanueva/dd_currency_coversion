//
//  AppConfig.swift
//  currencyConverter
//
//  Created by Nicks Villanueva on 10/14/22.
//

import Foundation
struct AppConfig: Codable {
    let commissionPercentage: Double
    let commissionFreeLimit: Int
    let transactionCount: Int

    enum CodingKeys: String, CodingKey {
        case commissionPercentage = "commission_percentage"
        case commissionFreeLimit = "commission_free_limit"
        case transactionCount = "transaction_count"
    }
}
