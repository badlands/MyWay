//
//  ViewController.swift
//  MyWay
//
//  Created by Marco on 30/06/16.
//  Copyright © 2016 Marco Marengo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let r = try! PlacesRequestModel(dictionary: [ "location" : "1234,12345", "query" : "Berlin "])
        print(r)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

