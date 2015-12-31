//
//  TimelineDetailViewController.swift
//  DailyPic
//
//  Created by Shaohui Yang on 12/21/15.
//  Copyright © 2015 Shaohui. All rights reserved.
//

import UIKit
import CoreData
import Dispatch
import CoreLocation

class TimelineDetailViewController: UIViewController {
//MARK: - outlets and variables
    var managedObjectContext: NSManagedObjectContext!
    weak var container: TimelineDetailTableViewController!
    var newEntry = false
    var keyboardIsUp = false
    var contentDidChange = false
    var findPlacemarkDidFinish = false
    var date = NSDate()
    //if pressed save and dissmiss view
    //savedEntry will make sure it will not be saved twice
    var savedEntry = false
    var isChoosingImage = false
    var entryToEdit: Entry!
    //locations variable
    var needEditLocation = true
    let locationManager = CLLocationManager()
    var updatingLocation = false
    var location: CLLocation?
    var lastLocationError: NSError?
    let geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    var performingReverseGeocoding = false
    var lastGeocodingError: NSError?
    var timer: NSTimer?
    
    @IBOutlet weak var doneOrEditButton: UIBarButtonItem!
    @IBAction func doneOrEdit(sender: AnyObject) {
        if keyboardIsUp {
        container.textView.resignFirstResponder()
            keyboardIsUp = false
        } else {
            if newEntry {
                dismissAndSave()
            } else {
                editMode()
                container.infoBar.addPhotoButton.enabled = true
            }
        }
    }
    func dismissAndSave(){
        let hudView = HudView.hudInView(navigationController!.view, animated: true)
        //saving entry to core data
        let entry: Entry?
        //if pressed save and dissmiss view
        //savedEntry will make sure it will not be saved twice
        if let temp = entryToEdit {
            //if editing detail hudView shows updated
            hudView.text = "Updated"
            entry = savedEntry ? nil : temp
        } else {
            hudView.text = "Saved"
            entry = savedEntry ? nil : (NSEntityDescription.insertNewObjectForEntityForName("Entry", inManagedObjectContext: managedObjectContext) as! Entry)
            entry?.photoID = nil
        }
        print("savedEntry: \(savedEntry)")
        if let entry = entry {
            entry.text = container.textView.text
            entry.date = container.date
            if needEditLocation {
                entry.placemark = self.placemark
                entry.latitude = self.location!.coordinate.latitude
                entry.longitude = self.location!.coordinate.longitude
            }
            if let image = container.image {
                //save the photoID
                //if save new photo, abtain a new ID
                if !entry.hasPhoto {
                    entry.photoID = Entry.nextPhotoID()
                }
                //save the photo
                
                if let data = UIImageJPEGRepresentation(image, 0.5) {
                    do{
                        try data.writeToFile(entry.photoPath, options: .DataWritingAtomic)
                    } catch {
                        print("Error writing file: \(error)")
                    }
                }
            }

            //save the entry to core data
            do {
                try managedObjectContext.save()
            } catch {
                fatalError("Error: \(error)")
            }
            //update the indicator to saved
            savedEntry = true
        }
        newEntry = false
        //display the hudView at dismiss view
        HudView.afterDelay(0.6) {
            hudView.dismissHudView()
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
//MARK: - built in methods
    override func viewDidLoad() {
        super.viewDidLoad()
        if newEntry {
            locationPermissionAlert()
            location = nil
            lastLocationError = nil
            placemark = nil
            lastGeocodingError = nil
            startLocationManager()
            needEditLocation = true
            editMode()
        } else {
            viewMode()
            needEditLocation = false
            findPlacemarkDidFinish = true
        if entryToEdit.hasPhoto {
            if let image = entryToEdit.photoImage{
                container.showImage(image)
            }
        }
            container.textView.text = entryToEdit.text
            container.date = entryToEdit.date
            if let placemark = entryToEdit.placemark {
                container.cityAndState["city"] = placemark.locality
                container.cityAndState["state"] = placemark.administrativeArea
            }
        }
    }
    //tell user the location service is disabled
    func showLocationServiceDeniedAlert() {
        let alert = UIAlertController(title: "定位你没同意", message: "麻溜的去设置改同意了", preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(okAction)
        
        presentViewController(alert, animated: true, completion: nil)
        
    }
    //location permission alert
    func locationPermissionAlert() {
        let authStatus = CLLocationManager.authorizationStatus()
        
        if authStatus == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()//ask user for location permission
            return
        }
        
        if authStatus == .Denied || authStatus == .Restricted {
            showLocationServiceDeniedAlert()
            return
        }
    }
    func startLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            updatingLocation = true
            timer = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: "didTimeOut:", userInfo: nil, repeats: false)
        }
    }
    func stopLocationManager() {
        if updatingLocation {
            if let timer = timer {
                timer.invalidate()
            }
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            updatingLocation = false
        }
    }
    func updateLocationCellLabel() {
        if let placemark = placemark {
            container.infoBar.cityLabel.text = placemark.locality
            container.infoBar.stateLabel.text = placemark.administrativeArea
        }
    }
    
    func didTimeOut() {
        if location == nil {
            stopLocationManager()
            lastLocationError = NSError(domain: "MyLocationsErrorDomain", code: 1, userInfo: nil)
            
        }
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if container.textView.editable && !isChoosingImage{
            dismissAndSave()
        }
 
    }
    deinit {
        print("detail is gone")
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == segueIdentifiers.TimelineDetailContainer {
            container = segue.destinationViewController as! TimelineDetailTableViewController
            container.delegate = self
        }
    }
    
    func editMode() {

        container.textView.editable = true
        container.textView.becomeFirstResponder()
        doneOrEditButton.enabled = false
        newEntry = true
    }
    
    func viewMode() {
        doneOrEditButton.title = "Edit"
        container.textView.editable = false
        newEntry = false
    }
}

extension TimelineDetailViewController: TimelineDetailDelegate {
    func updateButton(shouldEnable: Bool) {
        contentDidChange = shouldEnable ? true : false
        doneOrEditButton.enabled = (contentDidChange && findPlacemarkDidFinish) ? true : false
    
    }
    func keyboardShow(adjustScreen: Bool) {
            keyboardIsUp = adjustScreen ? true : false
            doneOrEditButton.title = keyboardIsUp ? "Done" : "Save"
    }
    
    func isChoosingImage(didChosse: Bool, isChoosing: Bool) {
        if isChoosing {
            self.isChoosingImage = true
            container.textView.resignFirstResponder()
            container.textView.editable = true
        }
        if didChosse {
            self.isChoosingImage = false
            doneOrEditButton.enabled = true
            doneOrEditButton.title = "Save"
            savedEntry = false
            newEntry = true
        }
    }
}

extension TimelineDetailViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        if error.code == CLError.LocationUnknown.rawValue {
            return
        }
        lastLocationError = error
        
        stopLocationManager()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        
        if newLocation.timestamp.timeIntervalSinceNow < -5 {
            return
        }
        if newLocation.horizontalAccuracy < 0 {
            return
        }
        
        var distance = CLLocationDistance(DBL_MAX)
        if let location = location {
            distance = newLocation.distanceFromLocation(location)
        }
        
        if location == nil || location!.horizontalAccuracy > newLocation.horizontalAccuracy {
            lastLocationError = nil
            location = newLocation
            
            if newLocation.horizontalAccuracy <= locationManager.desiredAccuracy {
                stopLocationManager()
                if distance > 0 {
                    performingReverseGeocoding = false
                }
            }
            
            if !performingReverseGeocoding {
                performingReverseGeocoding = true
                self.geocoder.reverseGeocodeLocation(newLocation, completionHandler: {
                    placemarks, error in
                    self.lastGeocodingError = error
                    if error == nil, let p = placemarks where !p.isEmpty {
                        self.placemark = p.last!
                    } else {
                        self.placemark = nil
                    }
                    self.performingReverseGeocoding = false
                    self.updateLocationCellLabel()
                    self.findPlacemarkDidFinish = true
                    self.doneOrEditButton.enabled = (self.contentDidChange && self.findPlacemarkDidFinish) ? true : false
                })
            }
        }
    }
    
}