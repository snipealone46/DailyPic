//
//  TimelineDetailCell.swift
//  DailyPic
//
//  Created by Shaohui Yang on 12/22/15.
//  Copyright © 2015 Shaohui. All rights reserved.
//

import UIKit
import Darwin
private var dateFormatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.dateStyle = .FullStyle
    formatter.timeStyle = .ShortStyle
    return formatter
}()

protocol TimelineDetailCellDelegate: class {
    func imagePicker()
}
class TimelineDetailCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBAction func addPhoto(sender: AnyObject) {
        if addPhotoButton.enabled{
        delegate?.imagePicker()
        }
    }
    @IBOutlet weak var addPhotoButton: UIButton!
    weak var delegate: TimelineDetailCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    lazy var currentTime = NSDate()
    var date: NSDate?
    func updateTimeLabels(date: NSDate) {
        let dateString = dateFormatter.stringFromDate(date)
        let dsSplit = dateString.componentsSeparatedByString(", ")
        dayLabel.text = dsSplit[0]
        let s = NSString(string: dsSplit[1])
        dateLabel.text = String(s.substringWithRange(NSRange(location: 0, length: 3)) + " " + s.substringWithRange(NSRange(location: s.length - 2, length: 2)))
        timeLabel.text = dsSplit[2].componentsSeparatedByString(" ")[2] + " " + dsSplit[2].componentsSeparatedByString(" ")[3]
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
