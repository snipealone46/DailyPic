//
//  pictureViewCell.swift
//  DailyPic
//
//  Created by Shaohui Yang on 12/24/15.
//  Copyright © 2015 Shaohui. All rights reserved.
//

import UIKit
protocol pictureViewCelldelegate: class {
    func indexOfRowTapped(index: Int)
}
class pictureViewCell: UITableViewCell {
    @IBOutlet weak var picture_1: UIImageView!
    @IBOutlet weak var picture_2: UIImageView!
    @IBOutlet weak var picture_3: UIImageView!
    weak var cellDelegate: pictureViewCelldelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        let viewHeight = self.bounds.height
        let pics: [UIImageView] = [picture_1, picture_2, picture_3]
        self.pictures = pics
        for var i = 0; i < 3; i++ {
            let xPoint = Double(viewHeight) * Double(i) + (Double(i) + 1) * 5
            pics[i].frame = CGRect(x: CGFloat(xPoint), y: 5, width: viewHeight - 5, height: viewHeight - 5)
        }
    }
    var pictures = [UIImageView]()
    var indexRow = 0
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func imageTapped_0() {
            print(indexRow)
            cellDelegate?.indexOfRowTapped(indexRow * 3)
        
    }
    func imageTapped_1() {
        
            cellDelegate?.indexOfRowTapped(indexRow * 3 + 1)
        }
    
    func imageTapped_2() {
        
            cellDelegate?.indexOfRowTapped(indexRow * 3 + 2)
        
    }
    func configureForPhoto(entries: [Entry]) {
        var i = 0
        for entry in entries {
            if let photo = imageForEntry(entry){
                self.pictures[i].image = photo
                self.pictures[i].userInteractionEnabled = true
                self.pictures[i].addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("imageTapped_\(i)")))
            } else {
                self.pictures[i].image = drawCustomImage(CGSize(width: self.bounds.height - 5, height: self.bounds.height - 5)).resizedImageWithBounds(CGSize(width: self.bounds.height - 5, height: self.bounds.height - 5))
                self.pictures[i].userInteractionEnabled = false
            }
            i++
        }
    }
    func imageForEntry(entry: Entry) -> UIImage? {
            if entry.hasPhoto, let image = entry.photoImage {
                return image.resizedImageWithBounds(CGSize(width: self.bounds.height - 5, height: self.bounds.height - 5))
            }else {
                return nil
            }

    }
    func drawCustomImage(size: CGSize) -> UIImage {
        let bounds = CGRect(origin: CGPoint.zero, size: size)
        let opaque = false
        let scale: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetStrokeColorWithColor(context, UIColor.whiteColor().CGColor)
        CGContextSetLineWidth(context, 2.0)
        
        CGContextStrokeRect(context, bounds)
        CGContextBeginPath(context)
        CGContextMoveToPoint(context, CGRectGetMinX(bounds), CGRectGetMinY(bounds))
        CGContextAddLineToPoint(context, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds))
        CGContextMoveToPoint(context, CGRectGetMaxX(bounds), CGRectGetMinY(bounds))
        CGContextAddLineToPoint(context, CGRectGetMinX(bounds), CGRectGetMaxY(bounds))
        CGContextStrokePath(context)
    
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

}
