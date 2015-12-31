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
        static let pictureViewCell = "pictureViewCell"
        static let loadingCell = "LoadingCell"
    }
    
//MARK: - outlets and variables
    var isLoading = true
    var managedObjectContext: NSManagedObjectContext!
    var fetchedResultsController: NSFetchedResultsController!
    var fetchedResultsPhotoOnly: [Entry] = []
    var isLoadingFix = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        var cellNib = UINib(nibName: pictureCellIdentifier.pictureViewCell, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: pictureCellIdentifier.pictureViewCell)
        cellNib = UINib(nibName: pictureCellIdentifier.loadingCell, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: pictureCellIdentifier.loadingCell)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let results = fetchedResultsController.fetchedObjects, queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0){
            dispatch_async(queue) {
                self.fetchedResultsPhotoOnly = filterPhotoOnlyResults(results)
                dispatch_async(dispatch_get_main_queue()){
                    self.isLoading = false
                    self.tableView.reloadData()
                }
            }
        } else {
            self.isLoading = false
            
        }
        tableView.reloadData()
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let isLoadingFix = isLoading ? 1 : 0
        if fetchedResultsPhotoOnly.count != 0{
            return Int(ceil(Double(fetchedResultsPhotoOnly.count) / 3.0)) + isLoadingFix
        } else {
            return 0 + isLoadingFix
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return view.bounds.width / 3
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        isLoadingFix = isLoading ? 1 : 0
        if isLoading {
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(pictureCellIdentifier.loadingCell, forIndexPath: indexPath)
                let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
                spinner.startAnimating()
                return cell
            }
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(pictureCellIdentifier.pictureViewCell, forIndexPath: indexPath) as! pictureViewCell
            cell.cellDelegate = self
            cell.indexRow = indexPath.row - isLoadingFix
            var entries:[Entry] = []
            var picInRow = 3
            let photoStartIndex = (indexPath.row - isLoadingFix) * 3
            picInRow = ((indexPath.row + 1 - isLoadingFix) * 3 > fetchedResultsPhotoOnly.count) ? (fetchedResultsPhotoOnly.count % 3) : 3
            for var i = 0; i < picInRow; i++ {
                entries.append(fetchedResultsPhotoOnly[photoStartIndex + i])
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
        let entry = sender as! Entry
        let controller = segue.destinationViewController as! TimelineDetailViewController
        controller.entryToEdit = entry
        controller.managedObjectContext = managedObjectContext
    }
//MARK: - support methods
    
}

extension PictureViewController: pictureViewCelldelegate {
    func entryPicked(entry: Entry){
        performSegueWithIdentifier(segueIdentifiers.photoToDetail, sender: entry)
    }
}