//
//  AppConfiguration.swift
//  currencyConverter
//
//  Created by Nicks Villanueva on 10/14/22.
//

import Foundation
import RealmSwift

class AppConfiguration: Object {
    @Persisted(primaryKey: true) var configID = 1
    @Persisted var commisionPercentage: Double
    @Persisted var commissionFreeLimit: Int
    @Persisted var transactionCount: Int
}
