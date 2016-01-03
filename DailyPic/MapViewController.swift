//
//  MapViewController.swift
//  DailyPic
//
//  Created by Shaohui Yang on 1/2/16.
//  Copyright © 2016 Shaohui. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import CoreLocation

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    var managedObjectContext: NSManagedObjectContext!
    
    var isShowingLocations = true
    var entries = [Entry]()
    var fetchedResultsController: NSFetchedResultsController!
    @IBOutlet weak var switchButton: UIBarButtonItem!
    @IBAction func switchFunc(){
        if isShowingLocations {
            switchButton.title = "Locations"
            isShowingLocations = false
            let region = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 1000, 1000)
            mapView.setRegion(mapView.regionThatFits(region), animated: true)
            
        }
        else {
            switchButton.title = "Current Location"
            isShowingLocations = true
            showLocations()
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == segueIdentifiers.mapToDetail {
            let controller = segue.destinationViewController as! TimelineDetailViewController
            controller.managedObjectContext = managedObjectContext
            
            let button = sender as! UIButton
            let entry = entries[button.tag]
            controller.entryToEdit = entry
        }
    }
    
    func updateLocations() {
        entries = fetchedResultsController.sections![0].objects as! [Entry]
        
        mapView.addAnnotations(entries)
    }
    func showLocations() {
        let region = regionForAnnotations(entries)
        mapView.setRegion(region, animated: true)
    }
    func showEntryDetails(sender: UIButton) {
        performSegueWithIdentifier(segueIdentifiers.mapToDetail, sender: sender)
    }
    func regionForAnnotations(annotations: [MKAnnotation]) -> MKCoordinateRegion {
        var region: MKCoordinateRegion
        
        switch annotations.count {
        case 0:
            region = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 1000, 1000)
            
        case 1:
            let annotation = annotations[annotations.count - 1]
            region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 1000, 1000)
            
        default:
            var topLeftCoord = CLLocationCoordinate2D(latitude: -90, longitude: 180)
            var bottomRightCoord = CLLocationCoordinate2D(latitude: 90, longitude: -180)
            
            for annotation in annotations {
                topLeftCoord.latitude = max(topLeftCoord.latitude, annotation.coordinate.latitude)
                topLeftCoord.longitude = min(topLeftCoord.longitude, annotation.coordinate.longitude)
                bottomRightCoord.latitude = min(bottomRightCoord.latitude, annotation.coordinate.latitude)
                bottomRightCoord.longitude = max(bottomRightCoord.longitude, annotation.coordinate.longitude)
            }
            
            let center = CLLocationCoordinate2D(latitude: topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) / 2, longitude: topLeftCoord.longitude - (topLeftCoord.longitude - bottomRightCoord.longitude) / 2)
            let extraSpace = 2.0
            let span = MKCoordinateSpan(
                latitudeDelta: abs(topLeftCoord.latitude - bottomRightCoord.latitude) * extraSpace,
                longitudeDelta: abs(topLeftCoord.longitude - bottomRightCoord.longitude) * extraSpace)
            region = MKCoordinateRegion(center: center, span: span)
        }
        return mapView.regionThatFits(region)
    }
    override func viewDidLoad() {
        updateLocations()
        showLocations()
    }
    deinit {
        fetchedResultsController.delegate = nil
    }
    
}

extension MapViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        print("****************")
        print("HERE")
        guard annotation is Entry else {
            return nil
        }
        //ask the mapView to re-use an annotation view object. If it cannot find a recyclable annotation view, then you create a new one.
        let identifier = "Location"
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as! MKPinAnnotationView!
        if annotationView == nil {

            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.enabled = true
            annotationView.canShowCallout = true
            annotationView.animatesDrop = false
            annotationView.pinTintColor = UIColor(red: 0.32, green: 0.82, blue: 0.4, alpha: 1)
            annotationView.tintColor = UIColor(white: 0.0, alpha: 0.5)
            //create a new UIButton object that looks like a detail disclosure button
            let rightButton = UIButton(type: .DetailDisclosure)
            rightButton.addTarget(self, action: Selector("showEntryDetails:"), forControlEvents: .TouchUpInside)
            annotationView.rightCalloutAccessoryView = rightButton
        } else {
            annotationView.annotation = annotation
        }
        //obtain a reference to that detail disclosure button again and set its tag to the index of the Location object in the locations array.
        let button = annotationView.rightCalloutAccessoryView as! UIButton
        if let index = entries.indexOf(annotation as! Entry) {
            button.tag = index
        }
        return annotationView
    }
}

extension MapViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        mapView.removeAnnotations(entries)
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        updateLocations()
    }
}