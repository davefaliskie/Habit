//
//  BadgesTableViewCell.swift
//  Habit
//
//  Created by David Faliskie on 3/19/17.
//  Copyright © 2017 David Faliskie. All rights reserved.
//

import UIKit
import CoreData

class BadgesTableViewCell: UITableViewCell {

    @IBOutlet weak var badgeImage: UIImageView!
    @IBOutlet weak var badgeTitle: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
