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
import RealmSwift

typealias PlacesCallback = (Array<Place>!, NSError?) -> Void
typealias RoutesCallback = (RoutesResponseModel!, NSError?) -> Void

extension Dictionary {
    mutating func merge<K, V>(dict: [K: V]){
        for (k, v) in dict {
            self.updateValue(v as! Value, forKey: k as! Key)
        }
    }
}

class PlacesApi {
    
    // TODO: a method which allows sorting by distance
    
    /***
     Retrieve a list of places from the HERE API service
    */
    // Example: https://places.cit.api.here.com/places/v1/discover/search?at=52.5310%2C13.3848&q=berlin&app_id=DemoAppId01082013GAL&app_code=AJKnXv84fjrb0KIHawS0Tg
    static func getPlaces(request: PlacesRequestModel, callback: PlacesCallback) {
        let url = "https://places.cit.api.here.com/places/v1/discover/search"
        
        let parameters = try! MTLJSONAdapter.JSONDictionaryFromModel(request) as! [String: AnyObject]        
        Alamofire.request(.GET, url, parameters: parameters, encoding: .URL, headers: nil)
            .validate()
            .responseJSON { (response) in
                if response.result.isFailure {
                    //callback(PlacesResponseModel(), response.result.error)
                    callback([], response.result.error)
                }
                else {
                    let placesModel = try! MTLJSONAdapter.modelOfClass(PlacesResponseModel.self, fromJSONDictionary:response.result.value as! [NSObject : AnyObject]) as! PlacesResponseModel
//                    callback(placesModel, nil)
                    
                    let mappedArray = placesModel.places.map({ (model) -> Place in
                        return Place(model: model)
                    })
                    callback(mappedArray, nil)
                    
                }
            }
    }
    
    /***
     Retrieve a route from the HERE API service
     */
    // Example: https://route.cit.api.here.com/routing/7.2/calculateroute.json?app_id=DemoAppId01082013GAL&app_code=AJKnXv84fjrb0KIHawS0Tg&waypoint0=geo!52.5,13.4&waypoint1=geo!52.5,13.45&mode=fastest;car;traffic:disabled&routeAttributes=sh,wp
    static func getRoute(request: RouteRequestModel, callback: RoutesCallback) {
        let url = "https://route.cit.api.here.com/routing/7.2/calculateroute.json"
        
        var parameters = try! MTLJSONAdapter.JSONDictionaryFromModel(request) as! [String: AnyObject]
        // TODO: find a better way
        var counter = 0
        let mappedWP = request.waypoints?.map { (string) -> [String : String] in
            let v = "geo!\(string)"
            let key = "waypoint\(counter)"
            counter += 1
            return [key : v]
        }
        mappedWP!.forEach({ (wpEntry) in
            parameters.merge(wpEntry)
        })

        
        Alamofire.request(.GET, url, parameters: parameters, encoding: .URL, headers: nil)
            .validate()
            .responseJSON { (response) in
                if response.result.isFailure {
                    callback(RoutesResponseModel(), response.result.error)
                }
                else {
                    let routesModel = try! MTLJSONAdapter.modelOfClass(RoutesResponseModel.self, fromJSONDictionary:response.result.value as! [NSObject : AnyObject]) as! RoutesResponseModel
                    callback(routesModel, nil)                    
                }
        }
    }
}
