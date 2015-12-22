//
//  MenuTableViewController.swift
//  DailyPic
//
//  Created by Shaohui Yang on 12/21/15.
//  Copyright © 2015 Shaohui. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {

    override func viewDidLoad() {
        let cellNib = UINib(nibName: "MenuCell", bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: "MenuCell")
    }
    
    deinit {
        print("menuTable is gone")
    }
//MARK: - table view methods
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as! MenuCell
        var listLabelName = ""
        switch indexPath.row {
        case 0:
            listLabelName = "Timeline"
        case 1:
            listLabelName = "Photos"
        case 2:
            listLabelName = "Tags"
        default:
            break
        }
        
        cell.listLabel.text = listLabelName
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.row {
        case 0:
            performSegueWithIdentifier("TimelineList", sender: nil)
        default: break
        }
        
    }
}
