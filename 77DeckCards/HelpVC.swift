//
//  HelpVC.swift
//  77DeckCards
//
//  Created by Reena on 08/06/20.
//  Copyright © 2020 Creations. All rights reserved.
//

import UIKit

class HelpVC: UIViewController {

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
        
    }
    

    @IBAction func btnBackTapAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
