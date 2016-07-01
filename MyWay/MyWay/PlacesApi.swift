//
//  PlacesApi.swift
//  MyWay
//
//  Created by Marco Marengo on 01/07/16.
//  Copyright © 2016 Marco Marengo. All rights reserved.
//

import Foundation
import Alamofire
import Mantle

// TODO: replace with typed array
typealias PlacesCallback = (PlacesResponseModel!, NSError?) -> Void

class PlacesApi {
    
    // https://places.cit.api.here.com/places/v1/discover/search?at=52.5310%2C13.3848&q=berlin&app_id=DemoAppId01082013GAL&app_code=AJKnXv84fjrb0KIHawS0Tg

    static func getPlaces(request: PlacesRequestModel, callback: PlacesCallback) {
        let url = "https://places.cit.api.here.com/places/v1/discover/search"
        
        let parameters = try! MTLJSONAdapter.JSONDictionaryFromModel(request) as! [String: AnyObject]        
        Alamofire.request(.GET, url, parameters: parameters, encoding: .URL, headers: nil)
            .validate()
            .responseJSON { (response) in
                if response.result.isFailure {
                    callback(PlacesResponseModel(), response.result.error)
                }
                else {
                    // TODO: map to model
                    
                    // ArticleListResponseModel *list = [MTLJSONAdapter modelOfClass:ArticleListResponseModel.class
                    // fromJSONDictionary:responseDictionary error:&error];
                    
                    
                    let placesModel = try! MTLJSONAdapter.modelOfClass(PlacesResponseModel.self, fromJSONDictionary:response.result.value as! [NSObject : AnyObject]) as! PlacesResponseModel
                    
                    callback(placesModel, nil)
                }
                
        }
    }
    
}
