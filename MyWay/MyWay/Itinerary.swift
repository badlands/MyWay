//
//  Itinerary.swift
//  MyWay
//
//  Created by Marco Marengo on 01/07/16.
//  Copyright © 2016 Marco Marengo. All rights reserved.
//

import Foundation
import RealmSwift
import CoreLocation

class Place : Object {
    dynamic var id : String = ""
    dynamic var title : String = ""
    dynamic var distance : Float = 0
    dynamic var iconUrl : String = ""
    dynamic var location : Location?
    
    convenience init(model: PlaceModel) {
        self.init()
        self.id = model.placeId
        self.title = model.title
        self.distance = model.distance
        self.iconUrl = model.iconUrl
        self.location = Location(coordinates: model.position)
    }
    
//    var coordinates : CLLocationCoordinate2D {
//        if position.count == 2 {
//            return CLLocationCoordinate2D(latitude: position[0] as! Double, longitude: position[1] as! Double)
//        }
//        else {
//            // TODO: better error handling
//            // currently returns null island
//            return CLLocationCoordinate2D(latitude: 0, longitude: 0)
//        }
//    }
}

class Itinerary : Object {
    dynamic var id : Int = 0
    let stops = List<Place>()
       
    // MARK: Realm
    override static func primaryKey() -> String? {
        return "id"
    }
    
    
//    convenience init(model: PlaceModel) {
//        init()
//        
//        self.stops = model.
//    }
}
