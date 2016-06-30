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

class PlacesRequestModel : MTLModel, MTLJSONSerializing {
    private(set) var query : String = ""
    private(set) var location : String = ""
    

    static func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]! {
        return [
            "query" : "q",
            "location" : "at"
        ]
    }

}