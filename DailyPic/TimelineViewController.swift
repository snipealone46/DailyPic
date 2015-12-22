//
//  TimelineViewController.swift
//  DailyPic
//
//  Created by Shaohui Yang on 12/21/15.
//  Copyright © 2015 Shaohui. All rights reserved.
//

import UIKit

class TimelineViewController: UITableViewController {
    
    var skipToDetail = false
    
    override func viewDidLoad() {

        let cellNib = UINib(nibName: "TimelineCell", bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: "TimelineCell")
        tableView.rowHeight = 80
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if skipToDetail {
            performSegueWithIdentifier("addNewEntry", sender: nil)
            skipToDetail = false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let controller = segue.destinationViewController as! TimelineDetailViewController
        if segue.identifier == "addNewEntry" {
            controller.newEntry = true
        } else {
            controller.newEntry = false
        }
    }
    deinit {
        print("timeline is gone")
    }
//MARK: - table view methods
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TimelineCell") as! TimelineCell
        cell.textView.text = "Hello World!"
        cell.textView.editable = false
        cell.timeLabel.text = "11:40 PM"
        cell.dayLabel.text = "Sat"
        cell.dateLabel.text = String(indexPath.row)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier("TimelineDetail", sender: nil)
    }
}
