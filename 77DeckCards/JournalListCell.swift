//
//  JournalListCell.swift
//  77DeckCards
//
//  Created by Reena on 14/05/20.
//  Copyright © 2020 Creations. All rights reserved.
//

import UIKit

class JournalListCell: UITableViewCell {

    
    @IBOutlet weak var lblDateLabel: UILabel!
    
    @IBOutlet weak var lblDesc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
