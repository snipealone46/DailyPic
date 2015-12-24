//
//  UIImage+Resize.swift
//  DailyPic
//
//  Created by Shaohui Yang on 12/24/15.
//  Copyright © 2015 Shaohui. All rights reserved.
//

import UIKit

extension UIImage {
    func resizedImageWithBounds(bounds: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds, true, 0)
        drawInRect(CGRect(origin: CGPoint.zero, size: bounds))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
