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


class FriendListVC: UIViewController,UITableViewDelegate,UITableViewDataSource,NVActivityIndicatorViewable
{
    
    @IBOutlet weak var tblFriendList: UITableView!
    
    var arrFriendsList : [FriendListResponse.Friend] = []
    

    //MARK: - View Life Cycle Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tblFriendList.contentInset = UIEdgeInsets(top: -35, left: 0, bottom: 0, right: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          
          self.LoadAllFriendlistWebApi()
      }
    
    @IBAction func btnBackTapAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: - UITableView Delegate & DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFriendsList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : FriendListCell = tableView.dequeueReusableCell(withIdentifier: "cellFriendList", for: indexPath) as! FriendListCell
        
        let obj : FriendListResponse.Friend = arrFriendsList[indexPath.row]
        
        cell.lblName.text = obj.name
        
        cell.lblPhone.text = obj.phone_no
        
        cell.ivProfilePic.layer.cornerRadius = cell.ivProfilePic.frame.size.height/2
        cell.ivProfilePic.layer.masksToBounds = true
        
        if obj.image != ""
        {
               cell.ivProfilePic.sd_setImage(with: URL(string: obj.image ?? ""), placeholderImage: UIImage(named: "userPlaceHolder"))//UIImage(named: card.image)
        }else
        {
            
        }
        
     
        
       // cell.lblName.text =
        
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
