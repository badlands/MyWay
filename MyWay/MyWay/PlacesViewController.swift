    //
//  PlacesViewController.swift
//  MyWay
//
//  Created by Marco Marengo on 01/07/16.
//  Copyright © 2016 Marco Marengo. All rights reserved.
//

import UIKit
import AlamofireImage
import RealmSwift
import CoreLocation
    
enum PVCCellIdentifier : String {
    case SearchResult = "placesCell"
    case Itinerary = "itineraryCell"
}

class PlacesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var placesTableView: UITableView!
    @IBOutlet weak var endSearchButtonItem: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    // TODO: move to enums, if necessary
    let itinerarySegue = "places2itinerary"
    
    var searchResult : Array<Place> = []
    lazy var itinerary : Itinerary = {
        return ItineraryManager.manager.getItinerary(1)
    }()
    
    var isSearching : Bool = false
    var locationManager : CLLocationManager = CLLocationManager()
    var userCoordinates : CLLocationCoordinate2D?
    
    // MARK: IBActions
    @IBAction func onShowItineraryTapped() {
        performSegueWithIdentifier(itinerarySegue, sender: nil)
    }
    
    @IBAction func onEditTapped(sender: AnyObject) {
        placesTableView.setEditing(!placesTableView.editing, animated: true)

        editButton.title = (placesTableView.editing) ? "Done" : "Edit"
    }
        
    // MARK: Internal methods
    func refreshPlaces(query: String) {
        // TODO: give UI feedback for this case
        if query.isEmpty {
            return
        }
        
        // Create the request
        let request = PlacesRequestModel()
        request.query = query
        request.location = userCoordinates != nil ? "\(userCoordinates!.latitude),\(userCoordinates!.longitude)" : "52.5310,13.3848"
        
        PlacesApi.getPlaces(request) { (results, error) in
            if error == nil {
                print("OK")
//                self.searchResult = results.places
                self.searchResult = results
                self.placesTableView.reloadData()
            }
            else {
                // handle error
                print(error)
            }

        }
    }
    
    func activateSearchMode() {
        isSearching = true
        endSearchButtonItem.enabled = true
        editButton.enabled = false
        
        
        placesTableView.setEditing(false, animated: true)
        placesTableView.backgroundColor = UIColor.lightGrayColor()
        placesTableView.reloadData()
        
        
    }
    
    func disableSearchMode() {
        isSearching = false
        endSearchButtonItem.enabled = false
        editButton.enabled = true
        
        searchTextField.text = ""
    
        searchTextField.resignFirstResponder()
        
//        placesTableView.setEditing(true, animated: true)
        placesTableView.backgroundColor = UIColor.clearColor()
        placesTableView.reloadData()
    }
    
    @IBAction func onEndSearchTapped(sender: AnyObject) {
        disableSearchMode()
    }
    
    // MARK: UITextField delegate
    func textFieldDidBeginEditing(textField: UITextField) {
        activateSearchMode()
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if let query = textField.text {
            refreshPlaces(query)
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: UITableView delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if isSearching {
//            let placeModel: PlaceModel = searchResult[indexPath.row]
//            let place = Place(model: placeModel)
            
            let place: Place = searchResult[indexPath.row]

            print("Should add: \(place.title)")
            
            // TODO: look for consecutive duplicates
            let realm = try! Realm()
            try! realm.write({
                itinerary.stops.append(place)
            })
            
            disableSearchMode()
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return !isSearching
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if isSearching {
            return
        }
        else {
            // Delete the object from the model
            print("Should delete itinerary stop at index: \(indexPath.row)")
            
            let realm = try! Realm()
            try! realm.write({
                itinerary.stops.removeAtIndex(indexPath.row)
            })
            placesTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        }
        
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return !isSearching
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        
        // Update the model
        let realm = try! Realm()
        try! realm.write({
            itinerary.stops.move(from: sourceIndexPath.row, to: destinationIndexPath.row)
            placesTableView.reloadData()
        })
    }
    
    // MARK: UITableView data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {        
        if isSearching {
            return searchResult.count
        }
        else {
            return itinerary.stops.count
        }
    }
    
    func searchCellForRowAtIndexPath(indexPath: NSIndexPath) -> PlacesCell {
        if let cell = placesTableView.dequeueReusableCellWithIdentifier(PVCCellIdentifier.SearchResult.rawValue) as? PlacesCell {
            let place: Place = searchResult[indexPath.row]
            
            // Update the cell accoring to the current place
            cell.titleLabel.text = place.title
            
            // make distance a bit more readable
            let unit = (place.distance >= 1000) ? "km" : "m"
            let readableDistance = (place.distance >= 1000) ? round(place.distance / 1000) : place.distance
            cell.distanceLabel.text = String(format: "%.0f %@", readableDistance, unit)
            
            if let imageUrl = NSURL(string: place.iconUrl) {
                cell.placeImageView.af_setImageWithURL(imageUrl)
            }
            else {
                cell.placeImageView.image = nil
            }
            
            return cell
        }
        else {
            return PlacesCell()
        }
    }
    
    func itineraryCellForRowAtIndexPath(indexPath: NSIndexPath) -> PlacesCell {
        
        if let cell = placesTableView.dequeueReusableCellWithIdentifier(PVCCellIdentifier.Itinerary.rawValue) as? PlacesCell {
            
            let stop = itinerary.stops[indexPath.row]
            cell.titleLabel.text = stop.title
            cell.distanceLabel.text = ""
            cell.placeImageView.image = indexPath.row == 0 ? UIImage(named: "start") : nil
            
            cell.backgroundColor = Colors(rawValue: (indexPath.row % 4)+1)?.UIColorRepresentation
            cell.titleLabel.textColor = UIColor.whiteColor()
            cell.titleLabel.font = UIFont.boldSystemFontOfSize(16.0)

            return cell
        }
        else {
            return PlacesCell()
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if isSearching {
            return searchCellForRowAtIndexPath(indexPath)
        }
        else {
            return itineraryCellForRowAtIndexPath(indexPath)
        }
    }
    
    // MARK: CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse || status == .AuthorizedAlways {
            locationManager.startUpdatingLocation()
        }
        else {
            print("locationManager error?")
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
    
        print("got location")
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            userCoordinates = locations.first!.coordinate
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("locationManager:didFailWithError: \(error.description)")
    }
    
    // MARK: UIViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == itinerarySegue {
            let vc = segue.destinationViewController as! RouteViewController
            vc.itinerary = itinerary
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.distanceFilter = 500
        if CLLocationManager.authorizationStatus() != .AuthorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
        }
        else {
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingLocation()
    }

}
