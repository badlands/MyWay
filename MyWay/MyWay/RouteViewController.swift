//
//  RouteViewController.swift
//  MyWay
//
//  Created by Marco on 02/07/16.
//  Copyright © 2016 Marco Marengo. All rights reserved.
//

import UIKit
import MapKit

/***
 This extension provides a method which removes HTML tags from a String
 */
extension String {
    func stringByRemovingHTMLTags() -> String {
        do {
            let regex:NSRegularExpression  = try NSRegularExpression( pattern: "<.*?>", options: NSRegularExpressionOptions.CaseInsensitive)
            let range = NSMakeRange(0, self.characters.count)
            return regex.stringByReplacingMatchesInString(self, options: NSMatchingOptions(), range:range , withTemplate: "")
        }
        catch {
            return self
        }
    }
}

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
    
    @IBOutlet weak var routeSummaryLabel: UILabel!
    
    var itinerary : Itinerary?
    var route : RouteModel?
    var mapAnnotations : [MKPointAnnotation]?
    
    func updateMapWithItinerary(itinerary: Itinerary) {
        // Clean the map
        mapView.removeAnnotations(mapView.annotations)
        
        // Create and add annotations
        mapAnnotations = itinerary.stops.map({ (place) -> MKPointAnnotation in
            print("adding " + place.title + " \(place.distance)")

            let annotation = MKPointAnnotation()
            annotation.title = place.title
            annotation.coordinate = place.location!.coordinate
            return annotation
        })
        mapView.addAnnotations(mapAnnotations!)
    }
    
    func updateUIWithRoute(route: RouteModel) {
        routeTableView.reloadData()
        
        routeSummaryLabel.text = "The trip takes \(route.travelTime)s. You will travel for \(route.distance)m"
        
        mapView.addOverlay(route.polyline, level: .AboveRoads)
        let rect = route.polyline.boundingMapRect
        
        // set appropriate region
        mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        
        // focus on the starting point
        if mapAnnotations != nil && mapAnnotations?.count > 0 {
            mapView.centerCoordinate = mapAnnotations![0].coordinate
        }
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
    
    @IBAction func toggleRouteDetails() {
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
    
    func refreshData() {
        // Create the request
        if itinerary != nil {
            let request = RouteRequestModel(itinerary: itinerary!)
            
            PlacesApi.getRoute(request) { (results, error) in
                if error == nil && results.routes.count > 0 {
                    self.route = results.routes.first
                    self.updateUIWithRoute(self.route!)
                }
                else {
                    // handle error
                    print(error)
                }
                
            }
        }
    }
    
    // MARK: UITableView delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if route != nil {
            return route!.legs[section].maneuvers.count
        }
        else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = routeTableView.dequeueReusableCellWithIdentifier(routeCellIdentifier) as! PlacesCell
        
        if route != nil {
            let leg = route!.legs[indexPath.section]
            
            cell.titleLabel.text = leg.maneuvers[indexPath.row].instruction.stringByRemovingHTMLTags()
            cell.distanceLabel.text = "\(leg.maneuvers[indexPath.row].length)m"
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return route != nil ? 60 : 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return route != nil ? route!.legs.count : 0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let leg = route!.legs[section]
        
        let cell : HeaderCell = routeTableView.dequeueReusableCellWithIdentifier("headerCell") as! HeaderCell
        cell.mainLabel.text = "From \(leg.startPlace) to \(leg.endPlace)"
        cell.detailLabel.text = "\(leg.maneuvers.count) maneuvers"
        return cell
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
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.redColor()
        renderer.lineWidth = 4.0
        
        return renderer
    }

    
    // MARK: UIViewController
    override func viewDidLoad() {
        self.title = "My itinerary"
    }
    
    override func viewWillAppear(animated: Bool) {
        if itinerary != nil {
            updateMapWithItinerary(itinerary!)
            refreshData()
        }
    }
}
