//
//  AppDelegate.swift
//  77DeckCards
//
//  Created by Himanshu Singla on 27/05/18.
//  Copyright © 2018 Creations. All rights reserved.
//

import UIKit
//import StoreKit
import IQKeyboardManagerSwift
import NVActivityIndicatorView
import SwiftMessages
import SwiftUI
import Reachability



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
//,SKProductsRequestDelegate, SKPaymentTransactionObserver
{
    var msgConfig = SwiftMessages.Config() //can change configuration.
   var msgView = MessageView.viewFromNib(layout: .cardView) //can change message text icon etc.
 let reachability = try! Reachability()
    
    var window: UIWindow?
    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    static let shared = UIApplication.shared.delegate as! AppDelegate
    fileprivate override init() {}

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //enable the IQKeyboard
                            IQKeyboardManager.shared.enable = true
                            
                            //message view
       
       
                            msgView.button?.isHidden = true
                            msgConfig.duration = .seconds(seconds: 3)
                            
                            msgConfig.presentationStyle = .top
                            msgView.configureTheme(.warning)
        
                            
                             //default setting loader indicator.
                            NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE = CGSize(width: 50, height: 50)
                            NVActivityIndicatorView.DEFAULT_TYPE = .circleStrokeSpin
                            NVActivityIndicatorView.DEFAULT_COLOR = commonVioletColor
        
        
         window = UIWindow(frame: UIScreen.main.bounds)
        let landingVC = mainStoryboard.instantiateViewController(withIdentifier: "LandingScreenOptionVC")
        let navigationController = UINavigationController(rootViewController: landingVC)
        navigationController.isNavigationBarHidden = true

        window?.rootViewController = navigationController
        
        window?.makeKeyAndVisible()
        
//        let skipDisclaimer = UserDefaults.standard.bool(forKey: "skipDisclaimer")
//        if skipDisclaimer {
//            self.perform(#selector(gotoHome), with: nil, afterDelay: 8.0)
//        } else {
//            self.perform(#selector(gotoDisclaimer), with: nil, afterDelay: 8.0)
//        }
//
        
        /// paypal payment gateway....
        PayPalMobile.initializeWithClientIds(forEnvironments: [PayPalEnvironmentProduction: "ASbrZynNPA8H8zSyCmtgeyBz222bP_1IbE_4jW2XyON_MJXKHy0PdPwFdZigUJzb8nlEpkmKo1FmT50N",
             PayPalEnvironmentSandbox: "ASbrZynNPA8H8zSyCmtgeyBz222bP_1IbE_4jW2XyON_MJXKHy0PdPwFdZigUJzb8nlEpkmKo1FmT50N"])
        
        return true
    }
    @objc func gotoDisclaimer()
    {
        
        let homeVC = mainStoryboard.instantiateViewController(withIdentifier: "DisclaimerVC") as! DisclaimerVC
        let navigationController = UINavigationController(rootViewController: homeVC)
        navigationController.isNavigationBarHidden = true
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
    }
    
    
    @objc func gotoHome(){
        
        let homeVC = mainStoryboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        let navigationController = UINavigationController(rootViewController: homeVC)
        navigationController.isNavigationBarHidden = true
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    
    //MARK: - Store Kit Delegate methods.
//    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
//           print("Show Product Request : \(response)")
//       }
//
//       func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
//
//        print("Show Updated Transaction : \(transactions)")
//
//       }
       

}

