//
//  MenuTableViewController.swift
//  DailyPic
//
//  Created by Shaohui Yang on 12/21/15.
//  Copyright © 2015 Shaohui. All rights reserved.
//

import UIKit
import CoreData

protocol indexOptionSelectedDelegate: class {
    func selectedViewController(segueTo: String)
}

class MenuTableViewController: UITableViewController {
    struct menuIndexNibIdentifier {
        static let indexCell = "MenuCell"
        static let loadingCell = "LoadingCell"
    }
//MARK: - outlets and variables
    var delegate: indexOptionSelectedDelegate?
    var isLoading = true
    var hasFetched = false
    var totalPhotoNum = 0
    var fetchedResultsController: NSFetchedResultsController!
//MARK: - built in methods
    override func viewDidLoad() {
        var cellNib = UINib(nibName: menuIndexNibIdentifier.indexCell, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: menuIndexNibIdentifier.indexCell)
        cellNib = UINib(nibName: menuIndexNibIdentifier.loadingCell, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: menuIndexNibIdentifier.loadingCell)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    deinit {
        print("menuTable is gone")
    }
//MARK: - table view methods
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            return 4
        } else {
            return 3
        }
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var indexFix = 0
        if isLoading{
            indexFix = 1
            if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(menuIndexNibIdentifier.loadingCell, forIndexPath: indexPath)
            let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
            spinner.startAnimating()
            return cell
            }
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(menuIndexNibIdentifier.indexCell, forIndexPath: indexPath) as! MenuCell
        switch indexPath.row - indexFix {
        case 0:
            cell.listLabel.text = "Timeline"
            cell.listCounter.text = hasFetched ? String(fetchedResultsController.sections![0].numberOfObjects) : String("0")
        case 1:
            cell.listLabel.text = "Photos"
            cell.listCounter.text = hasFetched ? String(totalPhotoNum) : String("0")
        case 2:
            cell.listLabel.text = "Map"
            cell.listCounter.hidden = true
        default:
            break
        }
        return cell
    }
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if isLoading {
            return nil
        } else {
            return indexPath
        }
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        var segueTo: String!
        switch indexPath.row {
        case 0:
            segueTo = segueIdentifiers.Timeline
        case 1:
            segueTo = segueIdentifiers.PhotoView
        case 2:
            segueTo = segueIdentifiers.MapView
        default: break
        }
        delegate?.selectedViewController(segueTo)
    }
}

