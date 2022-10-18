//
//  CurrencyPickerScreenViewModel.swift
//  currencyConverter
//
//  Created by Nicks Villanueva on 10/11/22.
//

import Foundation
import RxRelay

class CurrencyPickerScreenViewModel {
    
    public var currencyRelay : BehaviorRelay<[Currency?]>
    
    init() {
        currencyRelay = .init(value: [])
    }
    
    func getCurrencyData() {
        if let url = Bundle.main.url(forResource: "CurrencyData", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([Currency].self, from: data)
                self.currencyRelay.accept(jsonData)
            } catch {
                print("error:\(error)")
            }
        }
    }
    
}
