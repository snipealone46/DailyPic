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
    @IBOutlet weak var textView: UITextView!
    weak var doneButtonDelegate: TimelineDetailDoneButtonDelegate?
    
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