//
//  FriendListVC.swift
//  77DeckCards
//
//  Created by Reena on 06/05/20.
//  Copyright © 2020 Creations. All rights reserved.
//

import UIKit

class FriendListVC: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    
    @IBOutlet weak var tblFriendList: UITableView!
    

    //MARK: - View Life Cycle Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tblFriendList.contentInset = UIEdgeInsets(top: -35, left: 0, bottom: 0, right: 0)
    }
    
    
    //MARK: - UITableView Delegate & DataSource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : FriendListCell = tableView.dequeueReusableCell(withIdentifier: "cellFriendList", for: indexPath) as! FriendListCell
        
       // cell.lblName.text =
        
        return cell
        
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
