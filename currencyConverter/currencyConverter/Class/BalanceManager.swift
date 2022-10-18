//
//  BalanceManager.swift
//  currencyConverter
//
//  Created by Nicks Villanueva on 10/17/22.
//

import Foundation
import RealmSwift

class BalanceManager {
    
    public static let shared = BalanceManager()
    
    let realm = try! Realm()
    
    func getCommissionPercentage()-> Double {
        
        let appConfig = realm.objects(AppConfiguration.self)
        
        if let config = appConfig.first {
            return config.commisionPercentage
        }
        
        return 0.0
    }
    
    func getCommissionFreeLimit()-> Int{
        let appConfig = realm.objects(AppConfiguration.self)
        
        if let config = appConfig.first {
            return config.commissionFreeLimit
        }
        
        return 0
    }
    
    func getRemainingFreeTransaction()-> Int {
        let appConfig = realm.objects(AppConfiguration.self)
        
        if let config = appConfig.first {
            return config.transactionCount
        }
        
        return 0
    }
    
    func deductFreeTransaction() {
        
        let appConfig = realm.objects(AppConfiguration.self)
        
        if let config = appConfig.first {
            try! realm.write {
                config.transactionCount = config.transactionCount <= 0 ? 0 : config.transactionCount - 1
            }
        }
    }
    
    func calculateCommission(value:Double, percentageVal:Double)-> Double{
        let val = value * percentageVal
        return val / 100.0
    }
    
}
