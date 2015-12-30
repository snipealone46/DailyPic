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
private var shortDateFormatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.dateStyle = .ShortStyle
    formatter.timeStyle = .ShortStyle
    return formatter
}()
class pictureViewCell: UITableViewCell {
    @IBOutlet weak var picture_1: UIView!
    @IBOutlet weak var picture_2: UIView!
    @IBOutlet weak var picture_3: UIView!
    weak var cellDelegate: pictureViewCelldelegate?
    override func awakeFromNib() {
        super.awakeFromNib()

        let pics: [UIView] = [picture_1, picture_2, picture_3]
        self.pictures = pics
    }
    var pictures = [UIView]()
    var indexRow = 0
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func imageTapped_0() {
//            print(indexRow)
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
            let imageView = UIImageView()
            let view = self.pictures[i]
            let date = shortDateFormatter.stringFromDate(entry.date)
            if let photo = imageForEntry(entry){
                addImageView(view, imageView: imageView, photo: photo, dateString: date)
                view.userInteractionEnabled = true
                view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("imageTapped_\(i)")))
                
            } else if let text = entry.text{
                
                addTextView(view, text: text, dateString: date)
                view.userInteractionEnabled = true
                view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("imageTapped_\(i)")))
            }
                else {
                let whitePicture = drawCustomImage(CGSize(width: self.bounds.height - 5, height: self.bounds.height - 5))
                addImageView(view, imageView: imageView, photo: whitePicture, dateString: date)
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
    func addImageView(target: UIView, imageView: UIImageView, photo: UIImage, dateString: String){
        print(dateString)
        
        //create date label
        let dateView = UILabel(frame: CGRectMake(20, 100, 300, 40))
        dateView.text = dateString
        dateView.font = UIFont(name: dateView.font!.fontName, size: 10)
        dateView.clipsToBounds = true
        dateView.layer.cornerRadius = 5
        dateView.backgroundColor = UIColor(red: 233/255, green: 1, blue: 1, alpha: 1)
        dateView.textAlignment = .Center
        dateView.sizeToFit()
        dateView.setContentHuggingPriority(300, forAxis: .Vertical)
        imageView.setContentHuggingPriority(299, forAxis: .Vertical)
        dateView.setContentCompressionResistancePriority(300, forAxis: .Vertical)
        imageView.setContentCompressionResistancePriority(299, forAxis: .Vertical)
        //create stack view for date label and image view
        let stackView = UIStackView(arrangedSubviews: [dateView, imageView])
        //configure the stack view
        stackView.axis = .Vertical
        stackView.alignment = .Center
        stackView.distribution = .Fill
        imageView.image = photo
        stackView.translatesAutoresizingMaskIntoConstraints = false
        target.addSubview(stackView)
        //add constraint for stack view
        let topConstraint = stackView.topAnchor.constraintEqualToAnchor(target.topAnchor, constant: 0)
        let leadingConstraint = stackView.leadingAnchor.constraintEqualToAnchor(target.leadingAnchor, constant: 0)
        let trailingConstraint = stackView.trailingAnchor.constraintEqualToAnchor(target.trailingAnchor, constant: 0)
        let bottomConstraint = stackView.bottomAnchor.constraintEqualToAnchor(target.bottomAnchor, constant: 0)
        topConstraint.active = true
        leadingConstraint.active = true
        trailingConstraint.active = true
        bottomConstraint.active = true

    }
    func addTextView(target: UIView, text: String, dateString: String) {
        //create two labels
        let dateView = UILabel(frame: CGRectMake(0, 0, 300, 40))
        let textView = UILabel(frame: CGRectMake(0, 0, 300, 40))
        textView.numberOfLines = 0
        textView.text = text
        textView.font = UIFont(name: textView.font!.fontName, size: 15)
        dateView.text = dateString
        dateView.font = UIFont(name: textView.font!.fontName, size: 10)
        dateView.backgroundColor = UIColor(red: 233/255, green: 1, blue: 1, alpha: 1)
        dateView.clipsToBounds = true
        dateView.layer.cornerRadius = 5
        
        dateView.setContentHuggingPriority(250, forAxis: .Vertical)
        dateView.setContentCompressionResistancePriority(250, forAxis: .Vertical)
        textView.setContentHuggingPriority(249, forAxis: .Vertical)
        textView.setContentCompressionResistancePriority(249, forAxis: .Vertical)
        dateView.sizeToFit()
        textView.sizeToFit()
        //create stack view for these two labels
        let stackView = UIStackView(arrangedSubviews: [dateView, textView])
        //configure the stack view
        stackView.axis = .Vertical
        stackView.alignment = .Fill
        stackView.distribution = .Fill
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        //add the stack view
        target.addSubview(stackView)
        //add constraints to the stack view
        let topConstraint = stackView.topAnchor.constraintEqualToAnchor(target.topAnchor, constant: 0)
        let leadingConstraint = stackView.leadingAnchor.constraintEqualToAnchor(target.leadingAnchor, constant: 0)
        let trailingConstraint = stackView.trailingAnchor.constraintEqualToAnchor(target.trailingAnchor, constant: 0)
        let bottomConstraint = stackView.bottomAnchor.constraintEqualToAnchor(target.bottomAnchor, constant: 0)
        topConstraint.active = true
        leadingConstraint.active = true
        trailingConstraint.active = true
        bottomConstraint.active = true
        
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
