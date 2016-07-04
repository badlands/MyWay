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

/**
 This class defines a Itinerary (persisted by Realm)
 */
class Itinerary : Object {
    dynamic var id : Int = 0
    let stops = List<Place>()
    
    // MARK: Realm
    override static func primaryKey() -> String? {
        return "id"
    }
}

/**
 This class defines a Place (persisted by Realm)
 */
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
}


