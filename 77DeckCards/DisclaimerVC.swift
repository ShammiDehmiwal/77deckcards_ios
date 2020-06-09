//
//  DisclaimerVC.swift
//  77DeckCards
//
//  Created by Himanshu Singla on 18/06/18.
//  Copyright © 2018 Creations. All rights reserved.
//

import UIKit

class DisclaimerVC: UIViewController {
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var cnstHeightNavBar: NSLayoutConstraint!
    
    @IBOutlet weak var btnCheckbox: UIButton!
    @IBOutlet weak var txtViewDisclaimer: UITextView!
    var screenOpenedFromHome = false
    override func viewDidLoad() {
        super.viewDidLoad()
        let stringAttributes = [
            NSAttributedStringKey.font : UIFont(name: "Amarante-Regular", size: 20.0)!] //"Satisfy"
            let string = txtViewDisclaimer.attributedText.mutableCopy() as! NSMutableAttributedString
            string.addAttributes(stringAttributes, range:  NSRange(location: 0, length: string.length))
            txtViewDisclaimer.attributedText = string
        
        txtViewDisclaimer.textColor = .white
        
//        if screenOpenedFromHome {
//            cnstHeightNavBar.constant = 76
//            viewBottom.isHidden = true
//        } else {
//            cnstHeightNavBar.constant = 0
//            viewBottom.isHidden = false
//        }

    }
    @IBAction func actionNext(_ sender: UIButton) {
        AppDelegate.shared.gotoHome()
    }
    @IBAction func actionDoNotShow(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        UserDefaults.standard.set(sender.isSelected, forKey: "skipDisclaimer")
        UserDefaults.standard.synchronize()
    }
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
