//
//  TimelineDetailTableViewController.swift
//  DailyPic
//
//  Created by Shaohui Yang on 12/21/15.
//  Copyright © 2015 Shaohui. All rights reserved.
//

import UIKit

protocol TimelineDetailDelegate: class{
    func updateButton(shouldEnable: Bool)
    func keyboardShow(adjustScreen: Bool)
    func isChoosingImage(didChosse: Bool, isChoosing: Bool)
}

class TimelineDetailTableViewController: UITableViewController {
    struct detailsNibIdentifier {
        static let detail = "TimelineDetailCell"
    }
    var date:NSDate!
    var image: UIImage?
    var cityAndState = ["city": "", "state": ""]
    @IBOutlet weak var textView: UITextView!
    weak var delegate: TimelineDetailDelegate?
    weak var infoBar: TimelineDetailCell!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: detailsNibIdentifier.detail, bundle: nil)
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        tableView.registerNib(cellNib, forCellReuseIdentifier: detailsNibIdentifier.detail)
        textView.clipsToBounds = true
        textView.layer.cornerRadius = 10.0
        
    }
    deinit {
        print("detailTable is gone")
    }
    
    func showImage(image: UIImage) {
        imageView.image = image
        imageView.hidden = false
        
    }
//MARK: - table view methods
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return (imageView.image == nil) ? 0 : 1
        } else {
            return 1
        }
    }
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        switch (indexPath.section, indexPath.row) {
        case (0,0):
            return nil
        default:
            return indexPath
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(detailsNibIdentifier.detail) as! TimelineDetailCell
        
        switch (indexPath.section, indexPath.row) {
        case (1,0):
            if (infoBar != nil) {
                return infoBar
            } else {
            cell.delegate = self
            if (self.date != nil) {
                cell.updateTimeLabels(self.date)
            } else {
                self.date = cell.currentTime
                cell.updateTimeLabels(self.date)
            }
            
            cell.addPhotoButton.enabled = (self.imageView.image == nil)
            cell.addPhotoButton.setTitle((self.imageView.image == nil) ? "Add Photo" : "Edit Photo"  , forState: .Normal)
            cell.cityLabel.text = cityAndState["city"]
            cell.stateLabel.text = cityAndState["state"]
            infoBar = cell
            return cell
            }
        default:
            return super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        }
        
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (1,0):
            return 80
        case (2,0):
            if imageView.hidden{
                return 44
            } else {
                return view.bounds.width
            }
        default:
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
}
//MARK: - extensions
extension TimelineDetailTableViewController: UITextViewDelegate {
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let oldText: NSString = textView.text
        let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: text)
        if newText.length > 0 {
            delegate?.updateButton(true)
        } else {
            delegate?.updateButton(false)
        }
        return true
    }
    func textViewDidBeginEditing(textView: UITextView) {
        delegate?.keyboardShow(true)
    }
    func textViewDidEndEditing(textView: UITextView) {
        delegate?.keyboardShow(false)
    }
    
}

extension TimelineDetailTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func takePhotoWithCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .Camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    func choosePhotoFromLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    func pickPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            showPhotoMenu()
        } else {
            choosePhotoFromLibrary()
        }
    }
    
    func showPhotoMenu() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .Default) {
            _ in self.takePhotoWithCamera()
        }
        alertController.addAction(takePhotoAction)
        let chooseFromLibraryAction = UIAlertAction(title: "Grab From Library", style: .Default)
            {
                _ in self.choosePhotoFromLibrary()
            }
        
        alertController.addAction(chooseFromLibraryAction)
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        image = info[UIImagePickerControllerEditedImage] as? UIImage
        if let image = image {
            showImage(image)
            infoBar.addPhotoButton.enabled = true
            delegate?.isChoosingImage(true, isChoosing: true)
            
        }
        self.tableView.reloadData()
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
extension TimelineDetailTableViewController: TimelineDetailCellDelegate {
    func imagePicker() {
        delegate?.isChoosingImage(false, isChoosing: true)
        pickPhoto()
    }
}