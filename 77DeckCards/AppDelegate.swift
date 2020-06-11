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

import Foundation
import Alamofire

import UserNotifications
import UserNotificationsUI
import Firebase
import FirebaseInstanceID
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,MessagingDelegate
//,SKProductsRequestDelegate, SKPaymentTransactionObserver
{
    var msgConfig = SwiftMessages.Config() //can change configuration.
   var msgView = MessageView.viewFromNib(layout: .cardView) //can change message text icon etc.
 let reachability = try! Reachability()
    
    // var iCurrentLeftMenuOption : Int = 0
       var strDeviceToken : String = ""
       var strDeviceUDID : String = ""
    
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
        
        FirebaseApp.configure()
           
               if #available(iOS 10.0, *) {
              // For iOS 10 display notification (sent via APNS)
               UNUserNotificationCenter.current().delegate = self

               let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                UNUserNotificationCenter.current().requestAuthorization(
              options: authOptions,
              completionHandler: {_, _ in })
              } else {
                let settings: UIUserNotificationSettings =
               UIUserNotificationSettings(types: [.alert, .badge, .sound],
              categories: nil)
              application.registerUserNotificationSettings(settings)
              }

          // For iOS 10 data message (sent via FCM
                Messaging.messaging().delegate = self
          Messaging.messaging().shouldEstablishDirectChannel = true
        
        
              application.registerForRemoteNotifications()
              
              //get application instance ID
                     InstanceID.instanceID().instanceID { (result, error) in
                         if let error = error {
                             print("Error fetching remote instance ID: \(error)")
                         } else if let result = result {
                             print("Remote instance ID token: \(result.token)")
                          
                         }
                     }
              
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

    
     // The callback to handle data message received via FCM for devices running iOS 10 or above.
      //  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any])
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any])
        {
            
    //           if let messageID = userInfo[gcmMessageIDKey] {
    //               print("Message ID: \(messageID)")
    //           }
                
               // Print full message.
               print("Push Click : \(userInfo)")
           }
        
           func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
               print("Unable to register for remote notifications: \(error.localizedDescription)")
           }
        
    
        func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String)
        {
            print("Firebase registration token: \(fcmToken)")
             
            self.strDeviceToken = fcmToken
                              
                              //if logged then update device token
            if fetchUserDetailInUserDefault(strKey: "myLoggedUser") != nil
                                                {
                                                    self.updateDeviceTokenWebApi()
                                     }
            
            
            let dataDict:[String: String] = ["token": fcmToken]
            NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
            // TODO: If necessary send token to application server.
            // Note: This callback is fired at each app startup and whenever a new token is generated.
           
        }
         
       // func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
            print("Received data message: \(remoteMessage.appData)")
            
            
        }
        

        func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

            let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})

            print("Device token: \(deviceTokenString)")
            
            let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
               print(token)
            
            Messaging.messaging().apnsToken = deviceToken
           
            AppUtility.showMsg(style: .top, theme: .success, strTitle: "Push Notificaiton", strMsg: "You are eligible for notification. APPLE DEVICE TOKEN : \(token)")
            
            //show alert
    //        var topWindow: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    //        topWindow?.rootViewController = UIViewController()
    //        topWindow?.windowLevel = UIWindow.Level.alert + 1
    //        let alert: UIAlertController =  UIAlertController(title: "Push Notificaiton", message: "You are eligible for notification. APPLE DEVICE TOKEN : \(token)", preferredStyle: .alert)
    //            alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (alertAction) in
    //                topWindow?.isHidden = true
    //                topWindow = nil
    //            }))
    //
    //        topWindow?.makeKeyAndVisible()
    //        topWindow?.rootViewController?.present(alert, animated: true, completion:nil)
           
             
        }
        
        
        
        //MARK: - UIApplicationDelegate Methods
        @available(iOS 10.0, *)
        func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            let userInfo = notification.request.content.userInfo
            
            
            // Print message ID.
            //    if let messageID = userInfo[gcmMessageIDKey]
            //    {
            //      print("Message ID: \(messageID)")
            //    }
            
            // Print full message.
            print("Message : \(userInfo)")
            
            //    let code = String.getString(message: userInfo["code"])
          //  guard let aps = userInfo["aps"] as? Dictionary<String, Any> else { return }
          //  guard let alert = aps["alert"] as? String else { return }
            //    guard let body = alert["body"] as? String else { return }
            
          
//            let homeVC = mainStoryboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
//            homeVC.strFromWhere = "push"
//                   let navigationController = UINavigationController(rootViewController: homeVC)
//                   navigationController.isNavigationBarHidden = true
//
//                   window?.rootViewController = navigationController
//                   window?.makeKeyAndVisible()
            
            
            completionHandler([])
        }
        
        // Handle notification messages after display notification is tapped by the user.
        
        @available(iOS 10.0, *)
        func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            let userInfo = response.notification.request.content.userInfo
            
             NotificationCenter.default.post(name: Notification.Name("showCard"), object: nil, userInfo: ["cardId":userInfo["card_id"]!])
            
            print(userInfo)
            completionHandler()
        }

    
    
    func updateDeviceTokenWebApi()
                       {
                          // self.startAnimating() // show the loader.
                       
                        var iUserId : Int = 0
         
                               if let objUser = fetchUserDetailInUserDefault(strKey: "myLoggedUser")
                                     {
                                       iUserId = objUser.id
                               }
                    
                           print("Params : \(["user_id":iUserId,"device_token":appDelegate.strDeviceToken])")
                           
                         Alamofire.request(URL(string: "\(BASE_URL)/home/rest/add-device-token")!, method: .post, parameters: ["user_id":iUserId,"device_token":appDelegate.strDeviceToken], encoding: URLEncoding.default, headers: [:]).responseData { (response) in
                                 
                                  //  self.stopAnimating()// hide loader.
                                     
                                     switch(response.result) {
                                     case .success(let json):
                                         do {
                                             print("Success Response : \(json)")
                                             
                                             if let result = response.result.value {
                                                 //let json =  try JSON(data: result)
                                                 // print(json)
                                                 
                                                 // Convert the data to JSON
                                                 let jsonSerialized = try JSONSerialization.jsonObject(with: result, options: []) as? [String : Any]
                                               
                                               print("respoinse login : \(jsonSerialized)")
                                               
                                               let responseLogin = try! JSONDecoder().decode(AddJournalResponse.self, from: result)

                                                 print("update token api Response : \(responseLogin)")

                                               if responseLogin.status
                                                 {
                                                   // AppUtility.showMsg(style: .center, theme: .success, strTitle: "Success",strMsg: responseLogin.message) //responseLogin.message ?? ""
                                                       
                                                   
                                                 }else
                                               {
                                                 //  AppUtility.showMsg(style: .center, theme: .error, strTitle: "Error", strMsg: responseLogin.message) //responseLogin.message ?? ""
                                               }
                                                 
                                            }
                                             
                                             
                                         }  catch let error as NSError {
                                             print(error.localizedDescription)
                                             
                                           AppUtility.showMsg(style: .top, theme: .error, strTitle: "Error", strMsg: error.localizedDescription)
                                           
                                           
                                         }
                                         break
                                     // Yeah! Hand response
                                     case .failure(let error):
                                         
                                         print(error.localizedDescription)
                                         
                                         appDelegate.msgView.configureContent(title: "Error", body: error.localizedDescription, iconText: "😳")
                                         
                                         // Show the message.
                                         SwiftMessages.show(config: appDelegate.msgConfig, view:  appDelegate.msgView)
                                         
                                         // display alert with error message
                                     }
                                 
                       }
                        
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

