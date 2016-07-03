//
//  RouteRequestModel.swift
//  MyWay
//
//  Created by Marco on 03/07/16.
//  Copyright © 2016 Marco Marengo. All rights reserved.
//

import Mantle

class RouteRequestModel: MTLModel, MTLJSONSerializing {
    var applicationId : String = "DemoAppId01082013GAL"
    var applicationCode : String = "AJKnXv84fjrb0KIHawS0Tg"
    var mode : String = "fastest;car;traffic:disabled"
    var routeAttributes : String = "sh,wp"
    var waypoints : [String]?
    
    static func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]! {
        return [
            "applicationId" : "app_id",
            "applicationCode" : "app_code",
            "mode": "mode",
            "routeAttributes" : "routeAttributes"
        ]
    }
    
    func extendedJSON() -> [NSObject : AnyObject] {
        var dict = try! MTLJSONAdapter.JSONDictionaryFromModel(self)
        
        for wp in 0..<waypoints!.count {
            
        }
        
        return dict
    }
}
