//
//  LandingScreenOptionVC.swift
//  77DeckCards
//
//  Created by Reena on 05/05/20.
//  Copyright © 2020 Creations. All rights reserved.
//

import UIKit
import Foundation
import NVActivityIndicatorView
import SwiftMessages
import Alamofire

import AVKit
import AVFoundation

class LandingScreenOptionVC: UIViewController,NVActivityIndicatorViewable {

    
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBOutlet weak var btnHelp: UIButton!
    
    @IBOutlet weak var btnUpgrade: UIButton!
    
    
    //subscription popup view.
    @IBOutlet weak var ivBlurView: UIImageView!
    @IBOutlet weak var vSubscriptionPopup: UIView!
    
    
    
    //MARK: - View Life Cycle Methods.
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
      fetchUserDetailWebApi()
        
       NotificationCenter.default.addObserver(
       self,
       selector: #selector(self.cardReceivedNotification(notification:)),
       name: Notification.Name("showCard"),
       object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if let objUser = fetchUserDetailInUserDefault(strKey: "myLoggedUser")
        {
                        //  strTOken = objUser.token ?? ""
            btnLogin.setTitle("Logout", for: .normal)
        }else
        {
             btnLogin.setTitle("Login", for: .normal)
        }
      
        if let objUser = fetchUserDetailInUserDefault(strKey: "myLoggedUser")
                                   {
                                       if objUser.subscribeStatus == 0
                                       {
                                           //show subscription popup.
                                        btnUpgrade.isHidden = false
                                       }else
                                       {
                                        btnUpgrade.isHidden = true
                                       }
                                      
                      }else
                      {
                          btnUpgrade.isHidden = false
                      }
        
    }
    
    override func viewWillLayoutSubviews() {
        
        btnLogin.layer.cornerRadius = btnLogin.frame.size.height/2
              
              btnLogin.layer.borderWidth = 2
              btnLogin.layer.borderColor = UIColor(displayP3Red: 234/255.0, green: 151/255.0, blue: 8/255.0, alpha: 1).cgColor
        
        
        btnHelp.layer.cornerRadius = btnHelp.frame.size.height/2
                     
                     btnHelp.layer.borderWidth = 2
                     btnHelp.layer.borderColor = UIColor(displayP3Red: 234/255.0, green: 151/255.0, blue: 8/255.0, alpha: 1).cgColor
               
       
    }
    
    

    //MARK: - Custom Methods.
    @objc func cardReceivedNotification(notification: Notification)
    {
        if let info = notification.userInfo
        {
            let strCardId : String = info["cardId"] as! String
            
            let homeVC = (storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC)
               
            homeVC.strFromWhere = "push"
            homeVC.strPushShowCardId = strCardId
            
            self.navigationController?.pushViewController(homeVC, animated: true)
        }
    }
    
    //popup action button
    @IBAction func btnCloseTapAction(_ sender: UIButton)
    {
       // vSubscriptionPopup.isHidden = true
                                                       ivBlurView.isHidden = true
                                                       UIView.transition(with: vSubscriptionPopup, duration: 0.5, options: .transitionFlipFromTop, animations: {
                                                           self.vSubscriptionPopup.isHidden = true
                                                           
                                                       })
    }
    
    @IBAction func btnUpgradeNowTapAction(_ sender: UIButton)
    {
       // vSubscriptionPopup.isHidden = false
                                                       ivBlurView.isHidden = true
                                                       UIView.transition(with: vSubscriptionPopup, duration: 0.5, options: .transitionFlipFromTop, animations: {
                                                           self.vSubscriptionPopup.isHidden = true
                                                           
                                                       })
        
        let vc = (storyboard?.instantiateViewController(withIdentifier: "SubscriptionVC") as? SubscriptionVC)!
                         
                           self.navigationController?.pushViewController(vc, animated: true)
        
        
        
    }
    
    //end.
    
    @IBAction func btnLoginTapAction(_ sender: UIButton)
    {
        if let objUser = fetchUserDetailInUserDefault(strKey: "myLoggedUser")
               {
                self.startAnimating()
                
                     removeUserDetailInUserDefault(strKey: "myLoggedUser")
                
                btnLogin.setTitle("Login", for: .normal)
                
                UIView.animate(withDuration: 2.0, animations: {
                    
                    self.stopAnimating()
                })
                
               }else
               {
                     let vc = (storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC)!
                                  
                                  self.navigationController?.pushViewController(vc, animated: true)
               }
        
       
    }
    
    @IBAction func btnHelpTapAction(_ sender: UIButton) {
        
        let helpVC = (storyboard?.instantiateViewController(withIdentifier: "HelpVC") as! HelpVC)
               
               self.navigationController?.pushViewController(helpVC, animated: true)
    }
    
    
    @IBAction func btnBrowserTapAction(_ sender: UIButton)
    {
        let homeVC = (storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC)
        
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
    
    @IBAction func btnAboutUsTapAction(_ sender: UIButton) {
        
        let vc = (storyboard?.instantiateViewController(withIdentifier: "DisclaimerVC") as? DisclaimerVC)!
                             
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnVideoTapAction(_ sender: UIButton)
    {
        if let objUser = fetchUserDetailInUserDefault(strKey: "myLoggedUser")
                            {
                                if objUser.subscribeStatus == 0
                                {
                                    //show subscription popup.
                                    vSubscriptionPopup.isHidden = false
                                                 ivBlurView.isHidden = false
                                                 UIView.transition(with: vSubscriptionPopup, duration: 0.5, options: .transitionFlipFromTop, animations: {
                                                     self.vSubscriptionPopup.isHidden = false
                                                     
                                                 })
                                }else
                                {
                                    let videoURL = URL(string: "http://myprojectdemonstration.com/development/spiritworkcard/uploads/videos/module_cards.mp4")
                                                      let player = AVPlayer(url: videoURL!)
                                                      let playerViewController = AVPlayerViewController()
                                                      playerViewController.player = player
                                                      self.present(playerViewController, animated: true) {
                                                          playerViewController.player!.play()
                                                      }
                                }
                               
               }else
               {
                   let vc = (storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC)!
                                                    
                    self.navigationController?.pushViewController(vc, animated: true)
               }
    }
    
    @IBAction func btnJournalTapAction(_ sender: UIButton)
    {
        if let objUser = fetchUserDetailInUserDefault(strKey: "myLoggedUser")
                                   {
                                    if objUser.subscribeStatus == 0
                                                                   {
                                                                       //show subscription popup.
                                                                    vSubscriptionPopup.isHidden = false
                                                                                                                   ivBlurView.isHidden = false
                                                                                                                   UIView.transition(with: vSubscriptionPopup, duration: 0.5, options: .transitionFlipFromTop, animations: {
                                                                                                                       self.vSubscriptionPopup.isHidden = false
                                                                                                                       
                                                                                                                   })
                                                                   }else
                                                                   {
                    let vc = (storyboard?.instantiateViewController(withIdentifier: "JournalListVC") as? JournalListVC)!
                                                    
                               self.navigationController?.pushViewController(vc, animated: true)
                                    }
                                       
                      }else
                      {
                          let vc = (storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC)!
                                                           
                           self.navigationController?.pushViewController(vc, animated: true)
                      }
    
    }
    
    @IBAction func btnCommunityTapAction(_ sender: UIButton)
    {
      
    }
    
    @IBAction func btnUpgradeTapAction(_ sender: UIButton)
    {
        if let objUser = fetchUserDetailInUserDefault(strKey: "myLoggedUser")
                           {
                            
             let vc = (storyboard?.instantiateViewController(withIdentifier: "SubscriptionVC") as? SubscriptionVC)!
                  
                    self.navigationController?.pushViewController(vc, animated: true)
              }else
              {
                  let vc = (storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC)!
                                                   
                    self.navigationController?.pushViewController(vc, animated: true)
              }
        
      
    }
    
    
    //MARK: - Web API
           func fetchUserDetailWebApi()
           {
            
            if let objUser = fetchUserDetailInUserDefault(strKey: "myLoggedUser")
                                     {
            
               self.startAnimating() // show the loader.
        
                                        Alamofire.request(URL(string: "\(BASE_URL)/home/rest/profile?id=\(objUser.id)")!, method: .get, parameters: [:], encoding: URLEncoding.default, headers: [:]).responseData { (response) in
                       //,"device_type":"2","device_token":appDelegate.strDeviceToken
                        self.stopAnimating()// hide loader.
                         
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
                                   
                                   let responseLogin = try! JSONDecoder().decode(LoginResponse.self, from: result)

                                     print("Login Response : \(responseLogin)")

                                   if responseLogin.status
                                     {
                                       if let objData : LoginResponse.LoginObject = responseLogin.data
                                       {
                                           var iSubscribeStatus : Int = 0
                                           
                                           if objData.subscribe != ""
                                           {
                                               iSubscribeStatus = Int(objData.subscribe ?? "0") ?? 0
                                           }
                                           
                                           let objUser  = UserDetail(iID: objData.id, iPhoneNumber: objData.phone_no ?? 0, iAppStatus: objData.app_status ?? 0, strCreatedAt: objData.created_at ?? "", strUpdatedAt: objData.updated_at ?? "", status: objData.status ?? "", strAccessToken: objData.access_token ?? "", strTokenExpire: objData.token_expires_at ?? 0, subscribeStatus: iSubscribeStatus)

                                      saveUserDetailInUserDefault(strKey : "myLoggedUser", obj : objUser)
                                           
                                           
                                       }

                                     }else
                                   {
                                       AppUtility.showMsg(style: .center, theme: .error, strTitle: "Error", strMsg: responseLogin.message) //responseLogin.message ?? ""
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
           }
           
   
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
