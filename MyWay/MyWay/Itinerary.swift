//
//  Itinerary.swift
//  MyWay
//
//  Created by Marco Marengo on 01/07/16.
//  Copyright © 2016 Marco Marengo. All rights reserved.
//

import Foundation
import RealmSwift

class Place : Object {
    dynamic var id : String = ""
    dynamic var title : String = ""
    
    convenience init(model: PlaceModel) {
        self.init()
        self.id = model.placeId
        self.title = model.title
    }
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
