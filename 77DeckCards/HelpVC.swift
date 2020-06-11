//
//  HelpVC.swift
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

class HelpVC: UIViewController,NVActivityIndicatorViewable
{

    @IBOutlet weak var tvHelpText: UITextView!
    
    //MARK: - View Life Cycle Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let stringAttributes = [
                   NSAttributedStringKey.font : UIFont(name: "Amarante-Regular", size: 20.0)!] //"Satisfy"
                   let string = tvHelpText.attributedText.mutableCopy() as! NSMutableAttributedString
                   string.addAttributes(stringAttributes, range:  NSRange(location: 0, length: string.length))
                   tvHelpText.attributedText = string
               
               tvHelpText.textColor = .white
        
        self.helpWebApi()
    }
    

    @IBAction func btnBackTapAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: - Web API
             func helpWebApi()
             {
                 self.startAnimating() // show the loader.
              
                 Alamofire.request(URL(string: "\(BASE_URL)/home/rest/help")!, method: .post, parameters: [:], encoding: URLEncoding.default, headers: [:]).responseData { (response) in
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
                                 
                                print("respoinse help : \(jsonSerialized ?? [:])")
                                 
                                 let responseLogin = try! JSONDecoder().decode(HelpShowResponse.self, from: result)
                                 
                                 print("help Response : \(responseLogin)")
                                 
                                 if responseLogin.status
                                 {
                                    if let objDataHelp = responseLogin.data
                                    {
                                         self.tvHelpText.attributedText = NSAttributedString(string: objDataHelp.description)
                                        
                                        let stringAttributes = [
                                                          NSAttributedStringKey.font : UIFont(name: "Amarante-Regular", size: 20.0)!] //"Satisfy"
                                        let string = self.tvHelpText.attributedText.mutableCopy() as! NSMutableAttributedString
                                                          string.addAttributes(stringAttributes, range:  NSRange(location: 0, length: string.length))
                                        self.tvHelpText.attributedText = string
                                                      
                                        self.tvHelpText.textColor = .white
                                        
                                       
                                    }
                                  
                                 }else
                                 {
                                     AppUtility.showMsg(style: .center, theme: .error, strTitle: "Error", strMsg: "Invalid Login , Please try again.") //responseLogin.message ?? ""
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
