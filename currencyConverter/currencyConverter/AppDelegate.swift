//
//  AppDelegate.swift
//  currencyConverter
//
//  Created by Nicks Villanueva on 10/8/22.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window : UIWindow?
    
    let realm = try! Realm()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if #available(iOS 13, *) {
            // do only pure app launch stuff, not interface stuff
       } else {
           
           let window = UIWindow(frame: UIScreen.main.bounds)
           
           let viewController = TransactionViewController()
           let navigation = UINavigationController(rootViewController: viewController)
           
           window.backgroundColor = .white
           window.rootViewController = navigation
           
           window.makeKeyAndVisible()

           self.window = window
           
           return true
       }
        
        configureInitialUserData()
        configureApplication()
        print("Realm File Path --> \(Realm.Configuration.defaultConfiguration.fileURL)")
        
       return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // MARK: Configuration Function
    
    func configureInitialUserData() {
        
        if realm.object(ofType: UserBalance.self, forPrimaryKey: "nvill02191991") == nil {
            if let url = Bundle.main.url(forResource: "UserInitialData", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    let balance = try decoder.decode(Balance.self, from: data)
                        try! realm.write({
                        let userBalance = UserBalance()
                            userBalance.userID = balance.userID
                            realm.add(userBalance)
                        })
                    self.configureBalanceCurrency(model: balance.userBalance)
                } catch {
                    print("error:\(error)")
                }
            }
        }
        
    }
    
    
    func configureBalanceCurrency(model: [UserCurrencyBalance]) {
        for (_, currentBalance) in model.enumerated() {
            try! realm.write({
                let userBalance = CurrentUserBalance()
                userBalance.amount = currentBalance.balance
                userBalance.currencyCode = currentBalance.code
                userBalance.currenySymbol = currentBalance.currencySymbol
                realm.add(userBalance)
            })
        }
        
        
        
        
        
//
//        try! realm.write({
//            let usd = USDBalance()
//                usd.usdBalance = initialBalance.first?.usdBalance ?? 0.0
//                usd.currencyCode = CurrencyOptions.usd.rawValue
//            realm.add(usd)
//        })
//
//        try! realm.write({
//            let jpy = JPYBalance()
//                jpy.jpyBalance = initialBalance.first?.jpyBalance ?? 0.0
//                jpy.currencyCode = CurrencyOptions.jpy.rawValue
//            realm.add(jpy)
//        })
        
    }
    
    func configureApplication() {
        if realm.object(ofType: AppConfiguration.self, forPrimaryKey: 1) == nil {
            if let url = Bundle.main.url(forResource: "AppConfiguration", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    let config = try decoder.decode(AppConfig.self, from: data)
                    
                    try! realm.write({
                    let appConfig = AppConfiguration()
                        appConfig.commisionPercentage = config.commissionPercentage
                        appConfig.commissionFreeLimit = config.commissionFreeLimit
                        appConfig.transactionCount = config.transactionCount
                    realm.add(appConfig)
                    })
                    
                } catch {
                    print("error:\(error)")
                }
            }
        }
    }


}

