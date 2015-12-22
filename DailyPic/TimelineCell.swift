//
//  TimelineCell.swift
//  DailyPic
//
//  Created by Shaohui Yang on 12/19/15.
//  Copyright © 2015 Shaohui. All rights reserved.
//

import UIKit

class TimelineCell: UITableViewCell {
//MARK: - outlets and variables
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
