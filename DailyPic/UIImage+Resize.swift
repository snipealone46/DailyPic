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
    class func rectWithColor(color: UIColor, width: CGFloat, height: CGFloat) -> UIImage {
        let rect = CGRectMake(0, 0, width, height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
