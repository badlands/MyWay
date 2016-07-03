//
//  RoutesResponseModel.swift
//  MyWay
//
//  Created by Marco on 04/07/16.
//  Copyright © 2016 Marco Marengo. All rights reserved.
//

import Mantle


//class LegModel : MTLModel {
//    
//}

class RouteModel: MTLModel, MTLJSONSerializing {
    dynamic var shape : [String] = []
//    dynamic var legs : Array<LegModel> = []
    dynamic var distance : Int = 0
    dynamic var travelTime : Int = 0
    
    static func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]! {
        return [
            "shape" : "shape",
//            "legs" : "leg",
            "distance": "summary.distance",
            "travelTime" : "summary.travelTime"
        ]
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