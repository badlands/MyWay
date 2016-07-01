//
//  ItineraryManager.swift
//  MyWay
//
//  Created by Marco Marengo on 01/07/16.
//  Copyright © 2016 Marco Marengo. All rights reserved.
//

import Foundation
import RealmSwift

class ItineraryManager {
    private static let _manager = ItineraryManager()
    
    static var manager : ItineraryManager {
        return _manager
    }
    
    static func sanityCheck() {
        let realm = try! Realm()
        print("Number of places: \(realm.objects(Place.self).count)")
        
        let itineraries = realm.objects(Itinerary.self)
        print("Number of itineraries: \(itineraries.count)")
        itineraries.forEach { (itinerary) in
            print(".. itinerary \(itinerary.id): \(itinerary.stops.count) stops")
        }
    
    }
    
    static func reset() {
        let realm = try! Realm()
        
        try! realm.write({ 
            realm.deleteAll()
        })
    }
    
    func getItinerary(id: Int) -> Itinerary {
        let realm = try! Realm()
        
        if let itinerary = realm.objectForPrimaryKey(Itinerary.self, key: id) {
            return itinerary
        }
        else {
            let itinerary = Itinerary()
            itinerary.id = 1
            
            // Add some stops...
            for i in 1...3 {
                let s = Place()
                s.title = "Place \(i)"
                itinerary.stops.append(s)
            }
            //
            
            try! realm.write {
                realm.add(itinerary)
            }
            
            return itinerary
        }
    }
}
