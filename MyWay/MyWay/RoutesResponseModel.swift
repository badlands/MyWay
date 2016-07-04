//
//  RoutesResponseModel.swift
//  MyWay
//
//  Created by Marco on 04/07/16.
//  Copyright © 2016 Marco Marengo. All rights reserved.
//

import Mantle
import MapKit
import CoreLocation

class ManeuverModel : MTLModel, MTLJSONSerializing {
    dynamic var instruction: String = ""
    dynamic var length: Int = 0
    
    static func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]! {
        return [
            "instruction" : "instruction",
            "length" : "length"
        ]
    }
}

class LegModel : MTLModel, MTLJSONSerializing {
    dynamic var maneuvers: Array<ManeuverModel> = []
    
    dynamic var startPlace: String = ""
    dynamic var endPlace: String = ""
    
    static func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]! {
        return [
            "maneuvers" : "maneuver",
            "startPlace" : "start.label",
            "endPlace" : "end.label"
        ]
    }
    
    // MARK: transformers
    class func maneuversJSONTransformer() -> NSValueTransformer {
        return MTLJSONAdapter.arrayTransformerWithModelClass(ManeuverModel.self)
    }
}

class RouteModel: MTLModel, MTLJSONSerializing {
    dynamic var shape : [String] = []
    dynamic var legs : Array<LegModel> = []
    dynamic var distance : Int = 0
    dynamic var travelTime : Int = 0
    
    static func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]! {
        return [
            "shape" : "shape",
            "legs" : "leg",
            "distance": "summary.distance",
            "travelTime" : "summary.travelTime"
        ]
    }
    
    var polyline : MKPolyline {
        var coordinates = shape.map { (coordinateString) -> CLLocationCoordinate2D in
            let arr = coordinateString.componentsSeparatedByString(",")
            if let latitude = Double(arr[0]), longitude = Double(arr[1]) {
                return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            }
            else {
                return CLLocationCoordinate2D(latitude: 0, longitude: 0)
            }
        }
        return MKPolyline(coordinates: &coordinates, count: coordinates.count)
    }
    
    // MARK: transformers
    class func legsJSONTransformer() -> NSValueTransformer {
        return MTLJSONAdapter.arrayTransformerWithModelClass(LegModel.self)
    }
}

class RoutesResponseModel: MTLModel, MTLJSONSerializing {
    dynamic var routes : Array<RouteModel> = []
    
    
    static func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]! {
        return [
            "routes" : "response.route"
        ]
    }
    
    // MARK: transformers
    class func routesJSONTransformer() -> NSValueTransformer {
        return MTLJSONAdapter.arrayTransformerWithModelClass(RouteModel.self)
    }
}