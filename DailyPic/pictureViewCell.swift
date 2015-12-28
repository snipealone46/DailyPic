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
            pics[i].userInteractionEnabled = true
            print("imageTapped_\(i)")
            pics[i].addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("imageTapped_\(i)")))
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
            let photo = imageForEntry(entry)
            self.pictures[i].image = photo
            i++
        }
        for picture in pictures {
            if picture.image == nil {
                picture.image = UIImage(named: "No Photo")!.resizedImageWithBounds(CGSize(width: self.bounds.height - 5, height: self.bounds.height - 5))
                picture.image = UIImage(named: "No Photo")!.resizedImageWithBounds(CGSize(width: self.bounds.height - 5, height: self.bounds.height - 5))
            }
        }
    }
    func imageForEntry(entry: Entry) -> UIImage {
            if entry.hasPhoto, let image = entry.photoImage {
                return image.resizedImageWithBounds(CGSize(width: self.bounds.height - 5, height: self.bounds.height - 5))
            }else {
                return UIImage(named: "No Photo")!
            }

    }

}