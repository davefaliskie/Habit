//
//  CustomCell.swift
//  Habit
//
//  Created by David Faliskie on 3/5/17.
//  Copyright © 2017 David Faliskie. All rights reserved.
//

import UIKit
import CoreData

class CustomCell: UITableViewCell {


    @IBOutlet weak var habitNameLabel: UILabel!
    @IBOutlet weak var daysCompleteLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
