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
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
      
        
        
        
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
        
     
        
    }
    
    override func viewWillLayoutSubviews() {
        
        btnLogin.layer.cornerRadius = btnLogin.frame.size.height/2
              
              btnLogin.layer.borderWidth = 2
              btnLogin.layer.borderColor = UIColor(displayP3Red: 234/255.0, green: 151/255.0, blue: 8/255.0, alpha: 1).cgColor
        
       
    }

    
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
        let videoURL = URL(string: "http://myprojectdemonstration.com/development/spiritworkcard/uploads/videos/module_cards.mp4")
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    @IBAction func btnJournalTapAction(_ sender: UIButton)
    {
        let vc = (storyboard?.instantiateViewController(withIdentifier: "JournalListVC") as? JournalListVC)!
                                    
               self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnCommunityTapAction(_ sender: UIButton)
    {
        if let objUser = fetchUserDetailInUserDefault(strKey: "myLoggedUser")
                     {
        let vc = (storyboard?.instantiateViewController(withIdentifier: "FriendListVC") as? FriendListVC)!
                                   
              self.navigationController?.pushViewController(vc, animated: true)
        }else
        {
            let vc = (storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC)!
                                             
                                             self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnUpgradeTapAction(_ sender: UIButton)
    {
        let vc = (storyboard?.instantiateViewController(withIdentifier: "SubscriptionVC") as? SubscriptionVC)!
      
                      self.navigationController?.pushViewController(vc, animated: true)
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
