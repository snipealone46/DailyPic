//
//  IndexCell.swift
//  DailyPic
//
//  Created by Shaohui Yang on 12/18/15.
//  Copyright © 2015 Shaohui. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
//MARK: - outlets and variables
    @IBOutlet weak var listLabel: UILabel!
    @IBOutlet weak var listIcon: UIImageView!
    @IBOutlet weak var listCounter: UILabel!
    @IBOutlet weak var listMoreIndicator: UIImageView!
    
//MARK: - built in functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
