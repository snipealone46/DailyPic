//
//  TimelineDetailViewController.swift
//  DailyPic
//
//  Created by Shaohui Yang on 12/21/15.
//  Copyright © 2015 Shaohui. All rights reserved.
//

import UIKit
import CoreData
import Dispatch

class TimelineDetailViewController: UIViewController {
//MARK: - outlets and variables
    var managedObjectContext: NSManagedObjectContext!
    weak var container: TimelineDetailTableViewController!
    var newEntry = false
    var date = NSDate()
    var savedEntry = false
    var entryToEdit: Entry!
    @IBOutlet weak var doneOrEditButton: UIBarButtonItem!
    @IBAction func doneOrEdit(sender: AnyObject) {
        if newEntry {
            dismissAndSave()
        } else {
            editMode()
        }
    }
    func dismissAndSave(){
            let hudView = HudView.hudInView(navigationController!.view, animated: true)
            //saving entry to core data
            let entry: Entry?
            if let temp = entryToEdit {
                hudView.text = "Updated"
                entry = savedEntry ? nil : temp
            } else {
                hudView.text = "Saved"
                entry = savedEntry ? nil : (NSEntityDescription.insertNewObjectForEntityForName("Entry", inManagedObjectContext: managedObjectContext) as! Entry)
            }
        if !savedEntry {
            entry!.text = container.textView.text
            entry!.date = container.date
        
            do {
                try managedObjectContext.save()
            } catch {
                fatalError("Error: \(error)")
            }
            savedEntry = true
        }
            newEntry = false
            HudView.afterDelay(0.6) {
                hudView.dismissHudView()
                self.navigationController?.popViewControllerAnimated(true)
            }
    }
    
//MARK: - built in methods
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if newEntry {
            editMode()
        } else {
            viewMode()
            container.textView.text = entryToEdit.text
            container.date = entryToEdit.date
        }
    }
    override func viewWillDisappear(animated: Bool) {
            super.viewWillDisappear(animated)
            if container.textView.editable {
                dismissAndSave()
            }
    }
    deinit {

        print("detail is gone")
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == segueIdentifiers.TimelineDetailContainer {
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