//
//  PlacesResponseModel.swift
//  MyWay
//
//  Created by Marco Marengo on 01/07/16.
//  Copyright © 2016 Marco Marengo. All rights reserved.
//

import Mantle

class PlacesResponseModel: MTLModel, MTLJSONSerializing {
    dynamic var places : Array<PlaceModel> = []

    static func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]! {
        return [
            "places" : "results.items"
        ]
    }
    
    // MARK: transformers
    class func placesJSONTransformer() -> NSValueTransformer {
        return MTLJSONAdapter.arrayTransformerWithModelClass(PlaceModel.self)
    }
}
