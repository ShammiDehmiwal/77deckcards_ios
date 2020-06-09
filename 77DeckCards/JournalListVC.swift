//
//  JournalListVC.swift
//  77DeckCards
//
//  Created by Reena on 14/05/20.
//  Copyright © 2020 Creations. All rights reserved.
//

import UIKit

import Foundation
import NVActivityIndicatorView
import SwiftMessages
import Alamofire


class JournalListVC: UIViewController,UITableViewDelegate,UITableViewDataSource,NVActivityIndicatorViewable
{

    @IBOutlet weak var tblJournalList: UITableView!
    
    var iPageId : Int = 1
    
    var currentPage : Int = 0
    var isLoadingList : Bool = true
    var isLastRecord : Bool = false
    var arrJournalList : [JournalListResponse.Journals.JournalObject] = []
    
    //MARK: - View Life Cycle Methods.
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
         tblJournalList.contentInset = UIEdgeInsets(top: -35, left: 0, bottom: 0, right: 0)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        iPageId = 1
        isLoadingList = true
        isLastRecord = false
        arrJournalList = []
        self.LoadAllJournallistWebApi(isPagination : false)
    }
    
    
    @IBAction func btnBackTapAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAdJournalTapAction(_ sender: UIButton)
    {
        let vc = (storyboard?.instantiateViewController(withIdentifier: "AddJournalVC") as? AddJournalVC)!
               
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK: - UITableView Delegate & DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrJournalList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : JournalListCell = tableView.dequeueReusableCell(withIdentifier: "cellJournalList", for: indexPath) as! JournalListCell
        
        let obj : JournalListResponse.Journals.JournalObject = arrJournalList[indexPath.row]
        
        cell.lblDateLabel.text = obj.add_date
        
        cell.lblDesc.text = obj.description
        
       // cell.lblName.text =
        
        return cell
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height) && !isLoadingList){
            
            if !self.isLastRecord //if last record not come, then check
            {
            iPageId = iPageId + 1
            self.isLoadingList = true
            self.LoadAllJournallistWebApi(isPagination: true)
            }
        }
    }

    //MARK: - Web API
          func LoadAllJournallistWebApi(isPagination : Bool)
          {
              self.startAnimating() // show the loader.
              
              Alamofire.request(URL(string: "\(BASE_URL)/home/rest/get_all_journal?page=\(iPageId)")!, method: .get, parameters: [:], encoding: URLEncoding.default, headers: [:]).responseData { (response) in
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
                              
                              let responseLogin = try! JSONDecoder().decode(JournalListResponse.self, from: result)
                              
                              print("card list Response : \(responseLogin)")
                              
                              if responseLogin.status
                              {
                                if let objJournals = responseLogin.data as? JournalListResponse.Journals
                                {
                                    if let arrJournals = objJournals.journals as? [JournalListResponse.Journals.JournalObject]
                                                                    {
                                                                        if arrJournals.count == 0
                                                                        {
                                                                            self.isLastRecord = true
                                                                        }
                                                                        
                                                                        self.isLoadingList = false
                                                                        if isPagination
                                                                        {
                                                                            self.arrJournalList.append(contentsOf: arrJournals)
                                                                                                                                                  self.tblJournalList.reloadData()
                                                                        }else
                                                                        {
                                                                            self.arrJournalList = arrJournals
                                                                                                                                                  self.tblJournalList.reloadData()
                                                                        }
                                                                        
                                                                      
                                    }
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
