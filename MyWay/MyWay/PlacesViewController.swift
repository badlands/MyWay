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

class PlacesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var placesTableView: UITableView!
    @IBOutlet weak var endSearchButtonItem: UIBarButtonItem!
    
    // TODO: move to enums, if necessary
    let placesCellIdentifier = "placesCell"
    let itinerarySegue = "places2itinerary"
    
    var searchResult : Array<PlaceModel> = []
    lazy var itinerary : Itinerary = {
        return ItineraryManager.manager.getItinerary(1)
    }()
    
    var isSearching : Bool = false
    
    // MARK: IBActions
    @IBAction func onShowItineraryTapped() {
        performSegueWithIdentifier(itinerarySegue, sender: nil)
    }
    
    @IBAction func onEditTapped(sender: AnyObject) {
        placesTableView.setEditing(!placesTableView.editing, animated: true)
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
        request.location = "52.5310,13.3848"
        
        PlacesApi.getPlaces(request) { (results, error) in
            if error == nil {
                print("OK")
                self.searchResult = results.places
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
        
        placesTableView.setEditing(false, animated: true)
        placesTableView.reloadData()
        
        placesTableView.backgroundColor = UIColor.lightGrayColor()
    }
    
    func disableSearchMode() {
        isSearching = false
        endSearchButtonItem.enabled = false
        placesTableView.reloadData()
        searchTextField.resignFirstResponder()
        
        placesTableView.backgroundColor = UIColor.clearColor()
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
            let placeModel: PlaceModel = searchResult[indexPath.row]
            let place = Place(model: placeModel)
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
        if isSearching {
            return false
        }
        else {
            return true
        }
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
//            placesTableView.reloadData()
        }
        
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
        
        if let cell = placesTableView.dequeueReusableCellWithIdentifier(placesCellIdentifier) as? PlacesCell {
            
            let place: PlaceModel = searchResult[indexPath.row]
            
            cell.contentView.backgroundColor = UIColor.clearColor()
            
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
        
        if let cell = placesTableView.dequeueReusableCellWithIdentifier(placesCellIdentifier) as? PlacesCell {
            
            let stop = itinerary.stops[indexPath.row]
            cell.titleLabel.text = stop.title
            cell.distanceLabel.text = ""
            cell.placeImageView.image = nil
            
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
    
    // MARK: UIViewController
    override func viewDidLoad() {
//        itinerary = ItineraryManager.manager.getItinerary(1)
        
//        placesTableView..
    }
}
