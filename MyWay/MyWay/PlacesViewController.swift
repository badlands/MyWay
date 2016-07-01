    //
//  PlacesViewController.swift
//  MyWay
//
//  Created by Marco Marengo on 01/07/16.
//  Copyright © 2016 Marco Marengo. All rights reserved.
//

import UIKit
import AlamofireImage

class PlacesViewController: UIViewController, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var placesTableView: UITableView!
    
    // TODO: move to enums, if necessary
    let placesCellIdentifier = "placesCell"
    let itinerarySegue = "places2itinerary"
    
    var places : Array<PlaceModel> = []
    
    @IBAction func onShowItineraryTapped() {
        performSegueWithIdentifier(itinerarySegue, sender: nil)
    }
    
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
                self.places = results.places
                self.placesTableView.reloadData()
            }
            else {
                // handle error
                print(error)
            }
        }
    }
    
    // MARK: UITextField delegate
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
    
    // MARK: UITableView data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = placesTableView.dequeueReusableCellWithIdentifier(placesCellIdentifier) as? PlacesCell {

            let place: PlaceModel = places[indexPath.row]
        
            // Update the cell accoring to the current place
            cell.titleLabel.text = place.title
            if let imageUrl = NSURL(string: place.iconUrl) {
                cell.placeImageView.af_setImageWithURL(imageUrl)
            }
            else {
                cell.placeImageView.image = nil
            }

            return cell
        }
        else {
            return UITableViewCell()
        }
    }
    
    // MARK: UIViewController
//    override func viewWillAppear(animated: Bool) {
//        refreshPlaces("airport")
//    }
}
