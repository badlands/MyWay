//
//  RouteViewController.swift
//  MyWay
//
//  Created by Marco on 02/07/16.
//  Copyright © 2016 Marco Marengo. All rights reserved.
//

import UIKit
import MapKit

class RouteViewController : UIViewController, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let routeCellIdentifier = "routeCell"
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
        }
    }
    
    var isRouteContainerMaximized = false
    @IBOutlet weak var routeContainerView: UIView!

    @IBOutlet weak var routeTableView: UITableView!
    @IBOutlet weak var routeContainerConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var infoContainerConstraint: NSLayoutConstraint!
    
    var itinerary : Itinerary?
    var mapAnnotations : [MKPointAnnotation]?
    
    func showItineraryDetail() {
//        itinerary?.stops.forEach({ (place) in
//            print("adding " + place.title + " \(place.distance)")
//            
//            let annotation = MKPointAnnotation()
//            annotation.title = place.title
//            annotation.coordinate = place.location!.coordinate
//            mapView.addAnnotation(annotation)
//        })
        
        mapAnnotations = itinerary?.stops.map({ (place) -> MKPointAnnotation in
            print("adding " + place.title + " \(place.distance)")

            let annotation = MKPointAnnotation()
            annotation.title = place.title
            annotation.coordinate = place.location!.coordinate
            return annotation
        })
        mapView.addAnnotations(mapAnnotations!)
    }
    
    func showPlaceDetailsForAnnotationAtIndex(index: Int) {
//        infoContainerConstraint.constant = 0
//        UIView.animateWithDuration(0.3) { 
//            self.view.layoutIfNeeded()
//        }
    }
    
    func hidePlaceDetails() {
//        infoContainerConstraint.constant = -120
//        UIView.animateWithDuration(0.3) {
//            self.view.layoutIfNeeded()
//        }
    }
    
    func toggleRouteDetails() {
        if isRouteContainerMaximized {
            hideRouteDetails()
        }
        else {
            showRouteDetails()
        }
    }
    
    func showRouteDetails() {
        routeContainerConstraint.constant = -mapView.frame.height
        UIView.animateWithDuration(0.3) {
            self.view.layoutIfNeeded()
        }
        
        isRouteContainerMaximized = true
    }
    
    func hideRouteDetails() {
        routeContainerConstraint.constant = -80
        UIView.animateWithDuration(0.3) {
            self.view.layoutIfNeeded()
        }
        
        isRouteContainerMaximized = false
    }
    
    // MARK: UITableView delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = routeTableView.dequeueReusableCellWithIdentifier(routeCellIdentifier) as! PlacesCell
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = UIColor.redColor()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(RouteViewController.toggleRouteDetails ))
        v.addGestureRecognizer(tapGesture)
        
        return v
    }
    
    // MARK: MapView delegate
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        print("mapView:didSelect")
        if let annotation = view.annotation as? MKPointAnnotation {
            let index = mapAnnotations?.indexOf(annotation)
            
            if index != nil {
                showPlaceDetailsForAnnotationAtIndex(index!)
            }
        }
    }
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        hidePlaceDetails()
    }
    
    // MARK: UIViewController
    
    override func viewWillAppear(animated: Bool) {
        if itinerary != nil {
            showItineraryDetail()
        }
    }
}
