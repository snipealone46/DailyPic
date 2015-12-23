//
//  HudView.swift
//  DailyPic
//
//  Created by Shaohui Yang on 12/23/15.
//  Copyright © 2015 Shaohui. All rights reserved.
//

import UIKit
import Dispatch


class HudView: UIView{
    var text = ""
    var view: UIView?
    class func hudInView(view: UIView, animated: Bool) -> HudView {
        let hudView = HudView(frame: view.bounds)
        hudView.opaque = false
        hudView.view = view
        view.addSubview(hudView)
        view.userInteractionEnabled = false
        hudView.showAnimated(animated)
        return hudView
    }
    func dismissHudView() {
        view?.userInteractionEnabled = true
        self.removeFromSuperview()
    }
    override func drawRect(rect: CGRect) {
        let boxWidth: CGFloat = 96
        let boxHeight: CGFloat = 96
        
        let boxRect = CGRect(
            x: round((bounds.size.width - boxWidth) / 2),
            y: round((bounds.size.height - boxWidth) / 2),
            width: boxWidth,
            height: boxHeight)
        
        let roundedRect = UIBezierPath(roundedRect: boxRect, cornerRadius: 10)
        UIColor(white: 0.3, alpha: 0.8).setFill()
        roundedRect.fill()
        //draw the rounded rectangle
        if let image = UIImage(named: "Checkmark") {
            let imagePoint = CGPoint(
                x: center.x - round(image.size.width / 2),
                y: center.y - round(image.size.height / 2) - boxHeight / 8)
            image.drawAtPoint(imagePoint)
        }
        //put the text
        let attribs = [ NSFontAttributeName: UIFont.systemFontOfSize(16),
            NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        let textSize = text.sizeWithAttributes(attribs)
        
        let textPoint = CGPoint(
            x: center.x - round(textSize.width / 2),
            y: center.y - round(textSize.height / 2) + boxHeight / 4)
        
        text.drawAtPoint(textPoint, withAttributes: attribs)
    }
    
    func showAnimated(animated: Bool) {
        if animated {
            alpha = 0
            transform = CGAffineTransformMakeScale(1.3, 1.3)
            UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
                self.alpha = 1
                self.transform = CGAffineTransformIdentity
                }, completion: nil)
        }
    }
    class func afterDelay(seconds: Double, closure: () -> ()) {
        let when = dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(NSEC_PER_SEC)))
        dispatch_after(when, dispatch_get_main_queue(), closure)
    }
}
