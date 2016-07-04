//
//  Location.swift
//  MyWay
//
//  Created by Marco on 03/07/16.
//  Copyright © 2016 Marco Marengo. All rights reserved.
//

import RealmSwift
import CoreLocation

class Location: Object {
    dynamic var latitude = 0.0
    dynamic var longitude = 0.0
    
    convenience init(coordinates: NSArray) {
        self.init()
        self.latitude = coordinates[0] as! Double
        self.longitude = coordinates[1] as! Double
    }
    
    /// Get only computed properties are ignored in Realm
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude)
    }
    
    var coordinateString : String {
        return "\(latitude),\(longitude)"
    }
}