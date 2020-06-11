//
//  LoginVC.swift
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

class LoginVC: UIViewController,NVActivityIndicatorViewable {

    
    @IBOutlet weak var vPhoneNumberView: UIView!
    
    @IBOutlet weak var vPass: UIView!
    
    @IBOutlet weak var vLoginButton: UIView!
    @IBOutlet weak var txtPhone: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    
    
    //MARK: - View Life Cycle Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        
        vPhoneNumberView.layer.cornerRadius = vPhoneNumberView.frame.size.height/2
        
          vPass.layer.cornerRadius = vPass.frame.size.height/2
        
        
          vLoginButton.layer.cornerRadius = vLoginButton.frame.size.height/2
    }

    
    @IBAction func btnBackTapAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnLoginTapAction(_ sender: UIButton)
    {
        appDelegate.msgConfig.presentationStyle = .top
        
        if txtPhone.text == ""
              {
                  appDelegate.msgView.configureContent(title: "Warning", body: "Phone Number is required.", iconText: "🤔")
                  
             
                
               // AppUtility.showMsg(style: .top, theme: .warning, strTitle: "Warning", strMsg: "Phone Number is required")
                
                DispatchQueue.main.async {
                     SwiftMessages.show(config: appDelegate.msgConfig, view: appDelegate.msgView)
                }
                 
                  
              }else if txtPassword.text == ""
              {
                  appDelegate.msgView.configureContent(title: "Warning", body: "Password is required.", iconText: "🤔")
                            
                            // Show the message.
                            SwiftMessages.show(config: appDelegate.msgConfig, view: appDelegate.msgView)
                  
              }else
              {
                self.loginWebApi()
        }
    }
    
   
    @IBAction func btnRegisterHereTapAction(_ sender: UIButton)
    {
      
        let vc = (storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as? RegisterVC)!
        
        self.navigationController?.pushViewController(vc, animated: true)
        
      
    }
    
    
     //MARK: - Web API
        func loginWebApi()
        {
            self.startAnimating() // show the loader.
        
            Alamofire.request(URL(string: "\(BASE_URL)/home/rest/login")!, method: .post, parameters: ["phone_no":txtPhone.text!,"password":txtPassword.text!,"device_token":appDelegate.strDeviceToken], encoding: URLEncoding.default, headers: [:]).responseData { (response) in
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
                                        
                                        self.navigationController?.popViewController(animated: true)
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
        
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
