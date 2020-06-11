//
//  FriendListVC.swift
//  77DeckCards
//
//  Created by Reena on 06/05/20.
//  Copyright © 2020 Creations. All rights reserved.
//

import UIKit

import Foundation
import NVActivityIndicatorView
import SwiftMessages
import Alamofire

import SDWebImage

import Contacts
import ContactsUI

class FriendListVC: UIViewController,UITableViewDelegate,UITableViewDataSource,NVActivityIndicatorViewable
{
    
    @IBOutlet weak var tblFriendList: UITableView!
    
    var arrFriendsList : [FriendListResponse.Friend] = []
    
    var objSelectedCardObject : Card?
    
     var contacts = [CNContact]()
    
    //MARK: - View Life Cycle Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       // tblFriendList.contentInset = UIEdgeInsets(top: -35, left: 0, bottom: 0, right: 0)
        
       
       let keysToFetch = [
        CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
        CNContactPhoneNumbersKey,
        CNContactEmailAddressesKey,
        CNContactThumbnailImageDataKey] as! [CNKeyDescriptor]
        
        let request = CNContactFetchRequest(keysToFetch: keysToFetch)
        let contactStore = CNContactStore()
        
        do {
            try contactStore.enumerateContacts(with: request) {
                (contact, stop) in
                // Array containing all unified contacts from everywhere
                self.contacts.append(contact)
            }
        }
        catch {
            print("unable to fetch contacts")
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          
          self.LoadAllFriendlistWebApi()
      }
    
    
    //MARK: - UIButton Action Methods.
    @IBAction func btnBackTapAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func connected(sender: UIButton){
        let buttonTag = sender.tag
        
        if sender.titleLabel?.text == "Share"
        {
            let obj : FriendListResponse.Friend = arrFriendsList[buttonTag]
            //share action
            self.shareWebApi(iSelectedUser: Int(obj.id ?? "0") ?? 0)
        }
        
    }
    
    
    //MARK: - UITableView Delegate & DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0
        {
            return "Registered Users"
            
        }else if section == 1
        {
            return "Un-Registered Users"
        }
        
        return ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0
        {
            return arrFriendsList.count
            
        }else if section == 1
        {
            return self.contacts.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : FriendListCell = tableView.dequeueReusableCell(withIdentifier: "cellFriendList", for: indexPath) as! FriendListCell
       
        cell.btnAction.layer.cornerRadius = cell.btnAction.frame.size.height/2
                     
        cell.btnAction.layer.borderWidth = 2
        cell.btnAction.layer.borderColor = UIColor(displayP3Red: 234/255.0, green: 151/255.0, blue: 8/255.0, alpha: 1).cgColor
               
        cell.ivProfilePic.layer.cornerRadius = cell.ivProfilePic.frame.size.height/2
                     cell.ivProfilePic.layer.masksToBounds = true
        
        if indexPath.section == 0
        {
            cell.btnAction.setTitle("Share", for: .normal)
            
            let obj : FriendListResponse.Friend = arrFriendsList[indexPath.row]
                 
                 cell.lblName.text = obj.name
                 
                 cell.lblPhone.text = obj.phone_no
                 
             
                 
                 if obj.image != ""
                 {
                        cell.ivProfilePic.sd_setImage(with: URL(string: obj.image ?? ""), placeholderImage: UIImage(named: "userPlaceHolder"))//UIImage(named: card.image)
                 }else
                 {
                     
                 }
            
        }else
        {
            cell.btnAction.setTitle("Invite", for: .normal)
            
            let objContact = self.contacts[indexPath.row]
            
            cell.lblName.text = "\(objContact.namePrefix) \(objContact.givenName) \(objContact.familyName) \(objContact.nameSuffix)"
            
            if objContact.phoneNumbers.count > 0
            {
                let objPhoneNumber = objContact.phoneNumbers[0]
                
                cell.lblPhone.text = "\(objPhoneNumber.value.stringValue)"
                
               
            }
            
            
            
        }
   
        cell.btnAction.tag = indexPath.row
        cell.btnAction.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
        
        return cell
        
    }
    
    
    //MARK: - Web API
       func LoadAllFriendlistWebApi()
       {
           self.startAnimating() // show the loader.
           
        var iUserId : Int = 0
        
        if let objUser = fetchUserDetailInUserDefault(strKey: "myLoggedUser")
              {
                iUserId = objUser.id
        }
        
           Alamofire.request(URL(string: "\(BASE_URL)/home/rest/friends_list?id=\(2)")!, method: .get, parameters: [:], encoding: URLEncoding.default, headers: [:]).responseData { (response) in
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
                           
                           let responseLogin = try! JSONDecoder().decode(FriendListResponse.self, from: result)
                           
                           print("friend list Response : \(responseLogin)")
                           
                           if responseLogin.status
                           {
                            if let arrFriends = responseLogin.data as? [FriendListResponse.Friend]
                               {
                                    self.arrFriendsList = arrFriends
                                
                                self.tblFriendList.reloadData()
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
    
    
    //MARK: - Web API
    func shareWebApi(iSelectedUser : Int)
              {
                  self.startAnimating() // show the loader.
              
//               var iUserId : Int = 0
//
//                      if let objUser = fetchUserDetailInUserDefault(strKey: "myLoggedUser")
//                            {
//                              iUserId = objUser.id
//                      }
               
                print("Parameters : \(["user_id":iSelectedUser,"card_id":objSelectedCardObject?.id ?? ""])")
                
                Alamofire.request(URL(string: "\(BASE_URL)/home/rest/push-notification")!, method: .post, parameters: ["user_id":iSelectedUser,"card_id":objSelectedCardObject?.id ?? "0"], encoding: URLEncoding.default, headers: [:]).responseData { (response) in
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

                                        print("share api Response : \(responseLogin)")

                                      if responseLogin.status
                                        {
                                           AppUtility.showMsg(style: .center, theme: .success, strTitle: "Success",strMsg: responseLogin.message) //responseLogin.message ?? ""
                                              
                                          
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
