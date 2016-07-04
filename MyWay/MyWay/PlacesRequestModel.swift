//
//  PlacesRequestModel.swift
//  MyWay
//
//  Created by Marco on 30/06/16.
//  Copyright © 2016 Marco Marengo. All rights reserved.
//

import UIKit
import CoreLocation
import Mantle

/**
 This class defines the model of a Place Request
 */
class PlacesRequestModel : MTLModel, MTLJSONSerializing {
    var query : String = ""
    var location : String = ""
    var applicationId : String = "DemoAppId01082013GAL"
    var applicationCode : String = "AJKnXv84fjrb0KIHawS0Tg"
    
    static func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]! {
        return [
            "query" : "q",
            "location" : "at",
            "applicationId" : "app_id",
            "applicationCode" : "app_code",
        ]
    }

}