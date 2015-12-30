//
//  Entry.swift
//  DailyPic
//
//  Created by Shaohui Yang on 12/22/15.
//  Copyright © 2015 Shaohui. All rights reserved.
//

import UIKit
import CoreData

class Entry: NSManagedObject {
    var hasPhoto: Bool {
        return photoID != nil
    }
    
    var photoPath: String {
        assert(photoID != nil, "No photo ID set")
        let filename = "Photo-\(photoID!.integerValue).jpg"
        return (applicationDocumentsDirectory as NSString).stringByAppendingPathComponent(filename)
    }
    
    var photoImage: UIImage? {
        return UIImage(contentsOfFile: photoPath)
    }
    
    class func nextPhotoID() -> Int{
        let userDefaults = NSUserDefaults.standardUserDefaults()
        var currentID = userDefaults.integerForKey("PhotoID")
        let replaceID = userDefaults.integerForKey("replacePhotoID")
        let newID: Int!
        if (currentID != replaceID) {
            newID = replaceID
            currentID--
        } else {
            newID = currentID
        }
        userDefaults.setInteger(currentID + 1, forKey: "PhotoID")
        userDefaults.setInteger(currentID + 1, forKey: "replacePhotoID")
        userDefaults.synchronize()
//        print(newID)
        return newID
    }
    
    func removePhotoFile() {
        if hasPhoto {
            let path = photoPath
            let fileManager = NSFileManager.defaultManager()
            if fileManager.fileExistsAtPath(path) {
                do{
                    try fileManager.removeItemAtPath(path)
                    NSUserDefaults.standardUserDefaults().setInteger(Int(photoID!), forKey: "replacePhotoID")
                } catch {
                    print("Error removing file: \(error)")
                }
            }
        }
    }// Insert code here to add functionality to your managed object subclass

}
