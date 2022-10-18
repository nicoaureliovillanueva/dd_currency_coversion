//
//  TransactionViewModel.swift
//  currencyConverter
//
//  Created by Nicks Villanueva on 10/11/22.
//

import Foundation
import RxRelay
import Alamofire
import RealmSwift

class TransactionViewModel {
    
    let balanceManager = BalanceManager()
    
    var sellCurrencyCode: BehaviorRelay<String?>
    var recievedCurrencyCode: BehaviorRelay<String?>
    var convertedAmountRelay: BehaviorRelay<String?>
    var walletRelay: BehaviorRelay<[Wallet]>
    
    var walletArr: [Wallet]
    
    init() {
        self.sellCurrencyCode = .init(value: "")
        self.recievedCurrencyCode = .init(value: "")
        self.convertedAmountRelay = .init(value: "")
        self.walletRelay = .init(value: [])
        self.walletArr = []
        
    }
    
    func isValidAmount(amount: Double) -> Bool {
        let realm = try! Realm()
        let currentUserBalance = realm.objects(CurrentUserBalance.self).filter("currencyCode = %@", sellCurrencyCode.value)
        if let balance = currentUserBalance.first {
            
            let remainingAmount =  balance.amount - amount
            return remainingAmount > amount
            
        }
        
        return false
    }
    
    func getBalanceAmount()-> Double{
        
        return 0.0
    }
    
    func setSellCurrencyCode(code: String?) {
        sellCurrencyCode.accept(code)
    }
    
    func setRecievedCurrencyCode(code: String?) {
        recievedCurrencyCode.accept(code)
    }
    
    func getWalletDetails() {
        
        let realm = try! Realm()
        let details = realm.objects(CurrentUserBalance.self)
        for (_, walletItem) in details.enumerated() {
            
            let w = Wallet(amount: walletItem.amount,
                           currencyCode: walletItem.currencyCode,
                           currencySymbol: walletItem.currenySymbol)
            
            
            walletArr.append(w)
        }
        
        walletRelay.accept(walletArr)
        walletArr.removeAll()
    }
    
    func getCovertedCurrency(amount: String?) {
        
        if let a = amount, let s = sellCurrencyCode.value, let c = recievedCurrencyCode.value {
            let url = "http://api.evp.lt/currency/commercial/exchange/\(a)-\(s)/\(c)/latest"
            
            AF.request(url, method: .get).response { [weak self] response in
                guard let data = response.data else { return }
                print(data)
                
                do {
                    let decoder = JSONDecoder()
                    let exchangeData = try decoder.decode(Exchange.self, from: data)
                    
                    self?.convertedAmountRelay.accept("\(exchangeData.amount)")
                    
                } catch let error {
                    print(error)
                    self?.convertedAmountRelay.accept("")
                }
            }
        }
    }
    
    func proccessConvertion(sellAmount: Double) {
        
        if let receivedAmount = self.convertedAmountRelay.value {
                        
            
            addToWallet(recivedAmount: Double(receivedAmount) ?? 0.0,
                               currencyCode: recievedCurrencyCode.value ?? "")
            
            deductedToWallet(deductedAmount: sellAmount,
                               currencyCode: sellCurrencyCode.value ?? "")
            
        }
        
    }
    
    func isFreeTransaction()-> Bool{
        return balanceManager.getCommissionFreeLimit() <= 0
    }
    
    func addToWallet(recivedAmount: Double, currencyCode: String) {
        let realm = try! Realm()
        
        let currentUserBalance = realm.objects(CurrentUserBalance.self).filter("currencyCode = %@", currencyCode)
        
        if let balance = currentUserBalance.first {
            try! realm.write {
                balance.amount = balance.amount + recivedAmount
            }
            getWalletDetails()
        }
    }
    
    func getCommissionAmmount(deductedAmount: Double)-> Double {
        let commission = self.isFreeTransaction() ? 0 : balanceManager.calculateCommission(value: deductedAmount, percentageVal: balanceManager.getCommissionPercentage())
        
        return commission
    }
    
    func deductedToWallet(deductedAmount: Double, currencyCode: String) {
        let realm = try! Realm()
        
        balanceManager.deductFreeTransaction()
        
        let currentUserBalance = realm.objects(CurrentUserBalance.self).filter("currencyCode = %@", currencyCode)
        
        let commission = self.isFreeTransaction() ? 0 : balanceManager.calculateCommission(value: deductedAmount, percentageVal: balanceManager.getCommissionPercentage())
        
        if let balance = currentUserBalance.first {
            try! realm.write {
                balance.amount = (balance.amount - deductedAmount) - commission
            }
            getWalletDetails()
        }
    }
    
    
}
