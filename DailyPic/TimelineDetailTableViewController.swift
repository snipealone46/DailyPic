//
//  TimelineDetailTableViewController.swift
//  DailyPic
//
//  Created by Shaohui Yang on 12/21/15.
//  Copyright © 2015 Shaohui. All rights reserved.
//

import UIKit

protocol TimelineDetailDoneButtonDelegate: class{
    func updateButton(shouldEnable: Bool)
}

class TimelineDetailTableViewController: UITableViewController {
    struct detailsNibIdentifier {
        static let detail = "TimelineDetailCell"
    }
    var date:NSDate!
    
    @IBOutlet weak var textView: UITextView!
    weak var doneButtonDelegate: TimelineDetailDoneButtonDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: detailsNibIdentifier.detail, bundle: nil)
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        tableView.registerNib(cellNib, forCellReuseIdentifier: detailsNibIdentifier.detail)
        
    }
    deinit {
        print("detailTable is gone")
    }
//MARK: - table view methods
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        switch (indexPath.section, indexPath.row) {
        case (0,0):
            return nil
        default:
            return indexPath
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(detailsNibIdentifier.detail) as! TimelineDetailCell
        
        switch (indexPath.section, indexPath.row) {
        case (1,0):
            
            
            if (self.date != nil) {
                cell.updateTimeLabels(self.date)
            } else {
                self.date = cell.currentTime
                cell.updateTimeLabels(self.date)
            }
            cell.cityLabel.text = "El Monte"
            cell.stateLabel.text = ", CA"
            return cell
        default:
            return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        }
        
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (1,0):
            return 80
        default:
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
}
//MARK: - extensions
extension TimelineDetailTableViewController: UITextViewDelegate {
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let oldText: NSString = textView.text
        let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: text)
        if newText.length > 0 {
            doneButtonDelegate?.updateButton(true)
        } else {
            doneButtonDelegate?.updateButton(false)
        }
        return true
    }
}