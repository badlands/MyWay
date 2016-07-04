//
//  PlaceModel.swift
//  MyWay
//
//  Created by Marco Marengo on 01/07/16.
//  Copyright © 2016 Marco Marengo. All rights reserved.
//

import Foundation
import Mantle

/**
 This class defines the model of a Place
 */
class PlaceModel : MTLModel, MTLJSONSerializing {
    var title : String = ""
    var distance : Float = 0
    var iconUrl : String = ""
    var placeId : String = ""
    
    // TODO: switch to more precise type
    var position : NSArray = NSArray()
    
    static func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]! {
        return [
            "placeId": "id",
            "title" : "title",
            "distance" : "distance",
            "iconUrl" : "icon",
            "position" : "position"
        ]
    }
    
}
