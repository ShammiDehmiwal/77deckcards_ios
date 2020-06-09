//
//  AddJournalVC.swift
//  77DeckCards
//
//  Created by Reena on 08/06/20.
//  Copyright © 2020 Creations. All rights reserved.
//

import UIKit

import Foundation
import NVActivityIndicatorView
import SwiftMessages
import Alamofire

class AddJournalVC: UIViewController,UITextViewDelegate,NVActivityIndicatorViewable
{

    @IBOutlet weak var tvDescription: UITextView!
    
    @IBOutlet weak var vAddJournalBtn: UIView!
    
    
    //MARK: - View Life Cycle Methods.
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
       
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
          vAddJournalBtn.layer.cornerRadius = vAddJournalBtn.frame.size.height/2
    }
    
    //MARK: - UIButton Action Methods.
    @IBAction func btnBackTapAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddJournalSaveTapAction(_ sender: UIButton)
    {
        appDelegate.msgConfig.presentationStyle = .top
        
        if tvDescription.text == ""
              {
                  appDelegate.msgView.configureContent(title: "Warning", body: "Please enter description text.", iconText: "🤔")
                  
             
                
               // AppUtility.showMsg(style: .top, theme: .warning, strTitle: "Warning", strMsg: "Phone Number is required")
                
                DispatchQueue.main.async {
                     SwiftMessages.show(config: appDelegate.msgConfig, view: appDelegate.msgView)
                }
                 
                  
              }else
              {
                self.addJournalWebApi()
        }
       }
    
    //MARK: - UITextView Delegate Methods
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        if textView == tvDescription
        {
            if textView.text == "Enter Description Here"
            {
                textView.textColor = UIColor.black
                
                textView.text = ""
                
            }else
            {
                
            }
        }
        
        
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
    
        if textView == tvDescription
        {
            if textView.text == ""
            {
                textView.text = "Enter Description Here"
                
                textView.textColor = UIColor.darkGray
                
            }else
            {
                textView.textColor = UIColor.black
                
            }
        }
        
        return true
        
    }
    
    
    //MARK: - Web API
           func addJournalWebApi()
           {
               self.startAnimating() // show the loader.
           
            var iUserId : Int = 0
                   
                   if let objUser = fetchUserDetailInUserDefault(strKey: "myLoggedUser")
                         {
                           iUserId = objUser.id
                   }
            
            let dateFormat : DateFormatter = DateFormatter()
            dateFormat.dateFormat = "dd MMM yyyy hh:mm a"
            let strCurrentDate : String = dateFormat.string(from: Date())
            
            Alamofire.request(URL(string: "\(BASE_URL)/home/rest/addjournal")!, method: .post, parameters: ["user_id":iUserId,"description":tvDescription.text!,"date":strCurrentDate], encoding: URLEncoding.default, headers: [:]).responseData { (response) in
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
                                   
                                   let responseLogin = try! JSONDecoder().decode(AddJournalResponse.self, from: result)

                                     print("add journal Response : \(responseLogin)")

                                   if responseLogin.status
                                     {
                                        AppUtility.showMsg(style: .center, theme: .success, strTitle: "Success",strMsg: responseLogin.message) //responseLogin.message ?? ""
                                           
                                           self.navigationController?.popViewController(animated: true)
                                       
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
