//
//  TimelineViewController.swift
//  DailyPic
//
//  Created by Shaohui Yang on 12/21/15.
//  Copyright © 2015 Shaohui. All rights reserved.
//

import UIKit
import CoreData
protocol TimelineViewControllerDelegate: class {
    func updatePictureOnlyResults(changedEntry: Entry)
}
class TimelineViewController: UITableViewController {
//MARK: - outlets and variables
    var managedObjectContext: NSManagedObjectContext!
    var skipToDetail = false
    var fetchedResultsController: NSFetchedResultsController!
    var updateDelegate: TimelineViewControllerDelegate?
//MARK: - built in methods
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: "TimelineCell", bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: "TimelineCell")
        tableView.rowHeight = 80
        fetchedResultsController.delegate = self
    }
    deinit {
        fetchedResultsController.delegate = nil
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if skipToDetail {
            performSegueWithIdentifier(segueIdentifiers.addNewEntry, sender: nil)
            skipToDetail = false
        }
        
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let controller = segue.destinationViewController as! TimelineDetailViewController
        controller.managedObjectContext = managedObjectContext
        if segue.identifier == segueIdentifiers.addNewEntry {
            controller.newEntry = true
        } else {
            controller.newEntry = false
            let indexPath = sender as! NSIndexPath
            controller.entryToEdit = fetchedResultsController.objectAtIndexPath(indexPath) as! Entry
        }
    }
//MARK: - table view methods
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let entry = fetchedResultsController.objectAtIndexPath(indexPath) as! Entry
            entry.removePhotoFile()
            managedObjectContext.deleteObject(entry)
            do {
                try managedObjectContext.save()
                tableView.reloadData()
            } catch {
                print("HERE")
                fatalCoreDataError(error)
            }
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TimelineCell", forIndexPath: indexPath) as! TimelineCell
        let entry = fetchedResultsController.objectAtIndexPath(indexPath) as! Entry
//        print("*********************************")
//        print(entry)
//        print("*********************************")
        cell.configureForEntry(entry)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier(segueIdentifiers.TimelineDetail, sender: indexPath)
    }
}

extension TimelineViewController: NSFetchedResultsControllerDelegate {
        func controllerWillChangeContent(controller: NSFetchedResultsController) {
            self.tableView.beginUpdates()
        }
    
        func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
            switch type {
            case .Insert:
                self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            case .Delete:
                self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            case .Update:
                print("updated")
                if let cell = self.tableView.cellForRowAtIndexPath(indexPath!) as? TimelineCell {
                    let entry = controller.objectAtIndexPath(indexPath!) as! Entry
                    cell.configureForEntry(entry)
                }
            case .Move:
                self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
                self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            }
        }
    
        func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int,
            forChangeType type: NSFetchedResultsChangeType) {
            switch type {
        case .Insert:
                print("*** NSFetchedResultsChangeInsert (section)")
            self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete:
            print("*** NSFetchedResultsChangeDelete (section)")
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Update:
                print("*** NSFetchedResultsChangeUpdate (section)")
        case .Move:
            print("*** NSFetchedResultsChangeMove (section)")
            } }
        func controllerDidChangeContent(controller: NSFetchedResultsController) {
                self.tableView.endUpdates()
        }
}
