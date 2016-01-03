//
//  Entry.swift
//  DailyPic
//
//  Created by Shaohui Yang on 12/22/15.
//  Copyright © 2015 Shaohui. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class Entry: NSManagedObject, MKAnnotation {
    var hasPhoto: Bool {
        return photoID != nil
    }
    var photoPath: String {

        let filename = "Photo-\(photoID!.integerValue).jpg"
        return (applicationDocumentsDirectory as NSString).stringByAppendingPathComponent(filename)
    }
    
    var photoImage: UIImage? {
        return UIImage(contentsOfFile: photoPath)
    }
    //MKAnnotation
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(latitude, longitude)
    }
    var title: String? {
        if let text = text {
            return text
        } else {
            return "(No Description)"
        }
    }
    
    var subtitle: String? {
        return ""
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
