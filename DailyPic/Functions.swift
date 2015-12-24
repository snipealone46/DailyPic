//
//  Functions.swift
//  DailyPic
//
//  Created by Shaohui Yang on 12/23/15.
//  Copyright © 2015 Shaohui. All rights reserved.
//

import Foundation
import Dispatch

let applicationDocumentsDirectory: String = {
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
    return paths[0]
}()
