//
//  ViewController.swift
//  DailyPic
//
//  Created by Shaohui Yang on 12/21/15.
//  Copyright © 2015 Shaohui. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    weak var container: MenuTableViewController!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "menuContainer" {
            container = segue.destinationViewController as! MenuTableViewController
        } else if segue.identifier == "createNewEntry" {
            let controller = segue.destinationViewController as! TimelineViewController
            controller.skipToDetail = true
        }
    }
    deinit {
        print("menu is gone")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

