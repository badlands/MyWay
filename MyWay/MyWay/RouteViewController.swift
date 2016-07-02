//
//  RouteViewController.swift
//  MyWay
//
//  Created by Marco on 02/07/16.
//  Copyright © 2016 Marco Marengo. All rights reserved.
//

import UIKit
import MapKit

class RouteViewController : UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var itinerary : Itinerary?
    
    func showItineraryDetail() {
//        itinerary?.stops.map({ (place) -> String in
//            
//        })
        
        itinerary?.stops.forEach({ (place) in
            print(place.title + " \(place.distance)")
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: 45.111, longitude: 7.676767)
            mapView.addAnnotation(annotation)
        })
    }
    
    // MARK: UIViewController
    
    override func viewWillAppear(animated: Bool) {
        
        if itinerary != nil {
            showItineraryDetail()
        }
    }
}
