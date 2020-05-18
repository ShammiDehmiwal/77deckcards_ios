//
//  HomeVC.swift
//  77DeckCards
//
//  Created by Himanshu Singla on 27/05/18.
//  Copyright © 2018 Creations. All rights reserved.
//

import UIKit
import CenteredCollectionView

import Foundation
import NVActivityIndicatorView
import SwiftMessages
import Alamofire


class HomeVC: UIViewController,NVActivityIndicatorViewable
{
    
    @IBOutlet weak var cnstHeightError: NSLayoutConstraint!
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var viewError: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var clctnViewCards: UICollectionView!
    
    @IBOutlet weak var btnOptions: UIButton!
    
    
    var arrCards = [Card]()
    let cellPercentWidth: CGFloat = 0.8
    var centeredCollectionViewFlowLayout: CenteredCollectionViewFlowLayout!
    var selectedIndex: Int?
    var flippedIndex: Int?
    
    
    
    //MARK: - View Life Cycle Methods.
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
       // self.LoadAllCardWebApi()
        
          if let arrCardsTemp = loadJson(filename: "generated")
          {
                                                self.arrCards = arrCardsTemp
                                                self.configureCollectionView()
                                               // self.clctnViewCards.isHidden = true
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        if let _ = loadJson(filename: "generated") {
            shuffleCards()

        }
        
    }
    
    //MARK: - UIButton Action Methods.
    @IBAction func btnBackTapAction(_ sender: UIButton) {
        
        self.navigationController?.popToRootViewController(animated: true)
        
    }

    @IBAction func btnOptionTapAction(_ sender: UIButton) {
        
        //Create the AlertController and add Its action like button in Actionsheet
               let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Choose", message: "Option to select", preferredStyle: .actionSheet)
               
               let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                   print("Cancel")
               }
               actionSheetControllerIOS8.addAction(cancelActionButton)
               
                   let option1ActionButton = UIAlertAction(title: "Option 1", style: .default)
                   { _ in
                       print("Option 1 selected")
                    //   self.lblCompanyName.text = obj.company_name!
                   }
                   actionSheetControllerIOS8.addAction(option1ActionButton)
            
               let option2ActionButton = UIAlertAction(title: "Option 2", style: .default)
                                 { _ in
                                     print("Option 2 selected")
                                  //   self.lblCompanyName.text = obj.company_name!
                                 }
                                 actionSheetControllerIOS8.addAction(option2ActionButton)
        
        let option3ActionButton = UIAlertAction(title: "Option 3", style: .default)
                          { _ in
                              print("Option 3 selected")
                           //   self.lblCompanyName.text = obj.company_name!
                          }
                          actionSheetControllerIOS8.addAction(option3ActionButton)
        
               self.present(actionSheetControllerIOS8, animated: true, completion: nil)
        
    }
    
    
    //MARK:- Flip Reset Handler
    @objc func resetFlips() {
        if let flippedTempIndex = flippedIndex {
            let indexPath = IndexPath(item: flippedTempIndex, section: 0)
            if  let cell = clctnViewCards.cellForItem(at: indexPath) as? HomeCVC {
                cell.view2.isHidden = true
                cell.view1.isHidden = false
                
                btnOptions.isHidden = true
            }
        }
        clctnViewCards.isHidden = false
        flippedIndex = nil
    }
    @IBAction func actionBack(_ sender: UIButton) {
        let indexPath = IndexPath(item: selectedIndex!, section: 0)
        let cell = clctnViewCards.cellForItem(at: indexPath) as! HomeCVC
        let transitionOptions: UIViewAnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
        
        UIView.transition(with:  cell.view1, duration: 1.0, options: transitionOptions, animations: {
            cell.view2.isHidden = true
            
            self.btnOptions.isHidden = true
        })
        
        UIView.transition(with:  cell.view2, duration: 1.0, options: transitionOptions, animations: {
            cell.view1.isHidden = false
        })
        
        
        
        flippedIndex = nil
    }
    @IBAction func actionMenu(_ sender: UIButton) {
       // let disclaimerVC = self.storyboard?.instantiateViewController(withIdentifier: "DisclaimerVC") as! DisclaimerVC
      //  disclaimerVC.screenOpenedFromHome = true
      //  self.navigationController?.pushViewController(disclaimerVC, animated: true)
    }
    
    func shuffleCards() {
        //Shake Card
        selectedIndex = Int(arc4random_uniform(UInt32(arrCards.count)))
        self.clctnViewCards.scrollToItem(at: IndexPath(item: selectedIndex!, section: 0), at: .centeredHorizontally, animated: true)
        self.perform(#selector(resetFlips), with: nil, afterDelay: 0.3)
    }
    
    //MARK:- Shake Handler
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            shuffleCards()
        }
    }
    //MARK:- JSON Handler
    func loadJson(filename fileName: String) -> [Card]? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(ResponseData.self, from: data)
                return jsonData.card
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }


    
    //MARK:- Previous Next Handler
    @IBAction func actionNext(_ sender: UIButton) {
        if selectedIndex != nil && selectedIndex! <= arrCards.count - 2 {
            selectedIndex! += 1
            self.clctnViewCards.scrollToItem(at: IndexPath(item: selectedIndex!, section: 0), at: .centeredHorizontally, animated: true)
            self.perform(#selector(resetFlips), with: nil, afterDelay: 0.3)
        }  else {
            lblError.text = "Click on Left arrow to view more cards."
            DispatchQueue.main.async {
                self.cnstHeightError.constant = 50
                self.view.showAnimations { (true) in
                    self.perform(#selector(self.hideError), with: nil, afterDelay: 1.5)
                }
            }
            
        }
    }
    @IBAction func actionPrevious(_ sender: UIButton) {
        if selectedIndex != nil && selectedIndex! >= 1 {
            selectedIndex! -= 1
            self.clctnViewCards.scrollToItem(at: IndexPath(item: selectedIndex!, section: 0), at: .centeredHorizontally, animated: true)
            self.perform(#selector(resetFlips), with: nil, afterDelay: 0.3)
        } else {
            lblError.text = "Click on Right arrow to view more cards."
            DispatchQueue.main.async {
                self.cnstHeightError.constant = 50
                self.view.showAnimations { (true) in
                    self.perform(#selector(self.hideError), with: nil, afterDelay: 1.5)
                }
            }
            
        }
    }
    @objc func hideError() {
        self.cnstHeightError.constant = 0
        self.view.showAnimations()
    }
    //MARK:- Share Handler
    @IBAction func actionShare(_ sender: UIButton) {
        guard let selectedIndexTemp = self.selectedIndex else {
            return
        }
        let card = arrCards[selectedIndexTemp]
        let shareText = "\(card.desc)\n\nHey ! I'm using Spirit@Work Cards app. It's an amazing app, download it now from app store.\n https://itunes.apple.com/us/app/spirit-work-cards/id1419961752?ls=1&mt=8"
        //if let image = UIImage(named: card.imageLink) {
    
        print(card.imageLink)
        let vc = UIActivityViewController(activityItems: [card.imageLink,shareText], applicationActivities: [])
            vc.setValue("77DeckCards", forKey: "subject")
            
            present(vc, animated: true)
      //  }
    }
    
    func configureCollectionView() {
        // Get the reference to the `CenteredCollectionViewFlowLayout` (REQURED STEP)
        centeredCollectionViewFlowLayout = clctnViewCards.collectionViewLayout as! CenteredCollectionViewFlowLayout
        // Modify the collectionView's decelerationRate (REQURED STEP)
        clctnViewCards.decelerationRate = UIScrollViewDecelerationRateFast
        
        // Assign delegate and data source
        clctnViewCards.delegate = self
        clctnViewCards.dataSource = self
        
        // Configure the required item size (REQURED STEP)
        centeredCollectionViewFlowLayout.itemSize = CGSize(
            width: view.bounds.width * cellPercentWidth,
            height: view.bounds.height * cellPercentWidth * cellPercentWidth
        )
        
        // Configure the optional inter item spacing (OPTIONAL STEP)
        centeredCollectionViewFlowLayout.minimumLineSpacing = 30
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: - Web API
    func LoadAllCardWebApi()
    {
        self.startAnimating() // show the loader.
    
        Alamofire.request(URL(string: "\(BASE_URL)/home/rest/cards?page=0")!, method: .get, parameters: [:], encoding: URLEncoding.default, headers: [:]).responseData { (response) in
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
                            
                            let responseLogin = try! JSONDecoder().decode(CardListResponse.self, from: result)

                              print("card list Response : \(responseLogin)")

                            if responseLogin.status
                              {
                                if let objData = responseLogin.data
                                {
                                    if let arrRecords = objData.records as? [Card]
                                    {
                                        
                                        
                                        //if let arrCardsTemp = loadJson(filename: "generated") {
                                        self.arrCards = arrRecords
                                        
//                                        for obj in self.arrCards {
//                                            obj.imageLink = "https://pasteboard.co/J8iANZV.png"
//                                        }
                                        
                                        self.configureCollectionView()
                                       // self.clctnViewCards.isHidden = true
                                        self.clctnViewCards.reloadData()
                                        
                                      //  if let _ = loadJson(filename: "generated") {
                                        self.shuffleCards()
                                                   
                                       //        }
                                        
                                           //    }
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
    
    
    
}
