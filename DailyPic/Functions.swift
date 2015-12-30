//
//  Functions.swift
//  DailyPic
//
//  Created by Shaohui Yang on 12/30/15.
//  Copyright © 2015 Shaohui. All rights reserved.
//

import Foundation
import Dispatch
//these functions can be used anywhere
//() means Void
func afterDelay(seconds: Double, closure: Void -> ()) {
    let when = dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(NSEC_PER_SEC)))
    dispatch_after(when, dispatch_get_main_queue(), closure)
}

let applicationDocumentsDirectory: String = {
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
    return paths[0]
}()

func filterPhotoOnlyResults (results: [AnyObject]) -> [Entry]{
    let resultsUnwrapped = results.map {
        (result: AnyObject) -> Entry in
        let entry = result as! Entry
        return entry
    }
    let fetchedResultsPhotoOnly = resultsUnwrapped.filter{
        (result: Entry) -> Bool in
        
        return result.hasPhoto
    }
    return fetchedResultsPhotoOnly
}