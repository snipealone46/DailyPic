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
    var keyboardIsUp = false
    var date = NSDate()
    var savedEntry = false
    var isChoosingImage = false
    var entryToEdit: Entry!
    @IBOutlet weak var doneOrEditButton: UIBarButtonItem!
    @IBAction func doneOrEdit(sender: AnyObject) {
        if keyboardIsUp {
        container.textView.resignFirstResponder()
            keyboardIsUp = false
        } else {
            if newEntry {
                dismissAndSave()
            } else {
                editMode()
                container.infoBar.addPhotoButton.enabled = true
            }
        }
    }
    func dismissAndSave(){
            let hudView = HudView.hudInView(navigationController!.view, animated: true)
            //saving entry to core data
            let entry: Entry?
            if let temp = entryToEdit {
                print(savedEntry)
                hudView.text = "Updated"
                entry = savedEntry ? nil : temp
            } else {
                hudView.text = "Saved"
                entry = savedEntry ? nil : (NSEntityDescription.insertNewObjectForEntityForName("Entry", inManagedObjectContext: managedObjectContext) as! Entry)

            }
        if !savedEntry {
            
            
            entry!.text = container.textView.text
            entry!.date = container.date
            if let image = container.image {
                //save the photoID
                if !entry!.hasPhoto {
                    entry!.photoID = nil
                    entry!.photoID = Entry.nextPhotoID()
                }
                
                if let data = UIImageJPEGRepresentation(image, 0.5) {
                    do{
                        try data.writeToFile(entry!.photoPath, options: .DataWritingAtomic)
                    } catch {
                        print("Error writing file: \(error)")
                    }
                }
            }
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
    override func viewDidLoad() {
        super.viewDidLoad()
        if newEntry {
            editMode()
        } else {
            viewMode()
        if entryToEdit.hasPhoto {
            if let image = entryToEdit.photoImage{
                container.showImage(image)
            }
        }
            container.textView.text = entryToEdit.text
            container.date = entryToEdit.date
        }
    }

    override func viewWillDisappear(animated: Bool) {
            super.viewWillDisappear(animated)
            if container.textView.editable && !isChoosingImage{
                dismissAndSave()
            }
    }
    deinit {

        print("detail is gone")
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == segueIdentifiers.TimelineDetailContainer {
            container = segue.destinationViewController as! TimelineDetailTableViewController
            container.delegate = self
        }
    }
    
    func editMode() {

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

extension TimelineDetailViewController: TimelineDetailDelegate {
    func updateButton(shouldEnable: Bool) {
        doneOrEditButton.enabled = shouldEnable ? true : false
    
    }
    func keyboardShow(adjustScreen: Bool) {
            keyboardIsUp = adjustScreen ? true : false
            doneOrEditButton.title = keyboardIsUp ? "Done" : "Save"
    }
    
    func isChoosingImage(didChosse: Bool, isChoosing: Bool) {
        if isChoosing {
            self.isChoosingImage = true
            container.textView.resignFirstResponder()
            container.textView.editable = true
        }
        if didChosse {
            self.isChoosingImage = false
            doneOrEditButton.enabled = true
            doneOrEditButton.title = "Save"
            savedEntry = false
            newEntry = true
        }
    }
}