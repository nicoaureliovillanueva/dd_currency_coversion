//
//  UserBalance.swift
//  currencyConverter
//
//  Created by Nicks Villanueva on 10/14/22.
//

import Foundation
import RealmSwift

class UserBalance: Object {
    @Persisted(primaryKey: true) var userID: String
}
