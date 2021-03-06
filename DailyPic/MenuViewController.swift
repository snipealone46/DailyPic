//
//  ViewController.swift
//  DailyPic
//
//  Created by Shaohui Yang on 12/21/15.
//  Copyright © 2015 Shaohui. All rights reserved.
//

import UIKit
import CoreData

class MenuViewController: UIViewController {
//MARK: - outlets and variables
    var managedObjectContext: NSManagedObjectContext!
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("Entry", inManagedObjectContext: self.managedObjectContext)
        fetchRequest.entity = entity
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchBatchSize = 20
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: "entrys")
        return fetchedResultsController
        
    }()
    var fetchedResultsPhotoOnly = [Entry]()
//MARK: - built in methods
    override func viewDidLoad() {
        super.viewDidLoad()
        lazyLoading(true)
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
            readyToShow()
    }

    func readyToShow() {
            container.isLoading = false
            container.totalPhotoNum = self.fetchedResultsPhotoOnly.count
            container.hasFetched = true
   
    }
    func lazyLoading(performFetch: Bool) {
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(queue) {
            if performFetch{
                self.performFetch()
            }
            if let results = self.fetchedResultsController.fetchedObjects{
                self.fetchedResultsPhotoOnly = filterPhotoOnlyResults(results)
            }
            dispatch_async(dispatch_get_main_queue()) {
                //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                //delete after Delay for production
                //                HudView.afterDelay(0.5){
                self.readyToShow()
                self.container.tableView.reloadData()
                //                }
                
                //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            }
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        container.isLoading = true
        lazyLoading(false)
    }
    func performFetch() {
        do{
            try fetchedResultsController.performFetch()
            
        }catch {
            fatalCoreDataError(error)
        }
    }
    weak var container: MenuTableViewController!
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == segueIdentifiers.menuContainer {
            container = segue.destinationViewController as! MenuTableViewController
            container.delegate = self
            container.fetchedResultsController = fetchedResultsController
            
            
            
        } else if segue.identifier == segueIdentifiers.createNewEntry || segue.identifier == segueIdentifiers.Timeline{
            let controller = segue.destinationViewController as! TimelineViewController
            controller.managedObjectContext = managedObjectContext
            controller.skipToDetail = (segue.identifier == segueIdentifiers.createNewEntry) ? true : false
            controller.fetchedResultsController = fetchedResultsController
        } else if segue.identifier == segueIdentifiers.PhotoView {
            let controller = segue.destinationViewController as! PictureViewController
            controller.managedObjectContext = managedObjectContext
            print("photoOnly: \(self.fetchedResultsPhotoOnly.count)")
            print("all: \(self.fetchedResultsController.fetchedObjects?.count)")
            controller.fetchedResultsController = fetchedResultsController
            controller.fetchedResultsPhotoOnly = self.fetchedResultsPhotoOnly
        } else if segue.identifier == segueIdentifiers.MapView {
            let controller = segue.destinationViewController as! MapViewController
            controller.managedObjectContext = managedObjectContext
            controller.fetchedResultsController = fetchedResultsController
        }
        
    }
    deinit {
        fetchedResultsController.delegate = nil
        print("menu is gone")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MenuViewController: indexOptionSelectedDelegate {
    func selectedViewController(segueTo: String) {
        performSegueWithIdentifier(segueTo, sender: nil)
    }
}
