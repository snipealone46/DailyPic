//
//  TimelineDetailViewController.swift
//  DailyPic
//
//  Created by Shaohui Yang on 12/21/15.
//  Copyright © 2015 Shaohui. All rights reserved.
//

import UIKit

class TimelineDetailViewController: UIViewController {
    var newEntry = false
    @IBOutlet weak var doneOrEditButton: UIBarButtonItem!
    @IBAction func doneOrEdit(sender: AnyObject) {
        if newEntry {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            editMode()
            
        }
    }
    weak var container: TimelineDetailTableViewController!
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if newEntry {
            editMode()
        } else {
            viewMode()
        }
    }
    deinit {
        print("detail is gone")
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "TimelineDetailContainer" {
            container = segue.destinationViewController as! TimelineDetailTableViewController
            container.doneButtonDelegate = self
        }
    }
    
    func editMode() {
        doneOrEditButton.title = "Done"
        container.textView.editable = true
        container.textView.becomeFirstResponder()
        doneOrEditButton.enabled = false
        newEntry = true
    }
    
    func viewMode() {
        doneOrEditButton.title = "Edit"
        container.textView.editable = false
        newEntry = false
    }
}

extension TimelineDetailViewController: TimelineDetailDoneButtonDelegate {
    func updateButton(shouldEnable: Bool) {
        doneOrEditButton.enabled = shouldEnable ? true : false
    }
}