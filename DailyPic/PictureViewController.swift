//
//  PictureViewController.swift
//  DailyPic
//
//  Created by Shaohui Yang on 12/24/15.
//  Copyright © 2015 Shaohui. All rights reserved.
//

import UIKit
import CoreData


class PictureViewController: UITableViewController {
    struct pictureCellIdentifier {
        static let pictureViewCell = "pictureCell"
    }
    
//MARK: - outlets and variables
    var managedObjectContext: NSManagedObjectContext!
    var fetchedResultsController: NSFetchedResultsController!
    var totalPictureCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: "pictureViewCell", bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: pictureCellIdentifier.pictureViewCell)
        print(fetchedResultsController.fetchedObjects?.count)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let numberOfRows = self.fetchedResultsController.fetchedObjects?.count {
            totalPictureCount = numberOfRows
            return Int(ceil(Double(totalPictureCount) / 3.0))
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return view.bounds.width / 3
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(pictureCellIdentifier.pictureViewCell, forIndexPath: indexPath) as! pictureViewCell
            cell.cellDelegate = self
            cell.indexRow = indexPath.row
            var entries:[Entry] = []
            var picInRow = 3
            let photoStartIndex = NSIndexPath(forRow: indexPath.row * 3, inSection: 0)
            picInRow = ((indexPath.row + 1) * 3 > totalPictureCount) ? (totalPictureCount % 3) : 3
            for var i = 0; i < picInRow; i++ {

                let index = NSIndexPath(forRow: photoStartIndex.row + i, inSection: 0)
                
                if let entry = self.fetchedResultsController.objectAtIndexPath(index) as? Entry {
                            print("*********************************")
                            print(entry)
                            print("*********************************")
                    entries.append(entry)
                }
                
            }
            cell.configureForPhoto(entries)
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath = sender as! NSIndexPath
        let controller = segue.destinationViewController as! TimelineDetailViewController
        controller.entryToEdit = fetchedResultsController.objectAtIndexPath(indexPath) as! Entry
        controller.managedObjectContext = managedObjectContext
    }
//MARK: - support methods
    
}

extension PictureViewController: pictureViewCelldelegate {
    func indexOfRowTapped(index: Int) {
        print(index)
        let indexPath = NSIndexPath(forRow: index, inSection: 0)
        performSegueWithIdentifier(segueIdentifiers.photoToDetail, sender: indexPath)
    }
}
