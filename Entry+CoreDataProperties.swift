//
//  Entry+CoreDataProperties.swift
//  DailyPic
//
//  Created by Shaohui Yang on 12/22/15.
//  Copyright © 2015 Shaohui. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Entry {

    @NSManaged var text: String?
    @NSManaged var date: NSDate
    @NSManaged var photoID: NSNumber?
}
