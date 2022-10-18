//
//  CurrentUserBalance.swift
//  currencyConverter
//
//  Created by Nicks Villanueva on 10/14/22.
//

import Foundation
import RealmSwift

class CurrentUserBalance: Object {
    @Persisted var amount: Double
    @Persisted var currencyCode: String
    @Persisted var currenySymbol: String
}
