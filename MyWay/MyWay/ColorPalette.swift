//
//  ColorPalette.swift
//  MyWay
//
//  Created by Marco on 01/07/16.
//  Copyright © 2016 Marco Marengo. All rights reserved.
//

import Foundation
import UIKit

enum Colors : Int {
    case Violet = 1, Pink, Blue, Green

    var UIColorRepresentation : UIColor {
        switch self {
        case Violet:
            return UIColor(red: 229/255, green: 94/255, blue: 170/255, alpha: 0.4)
        case Pink: // 239,116,162
            return UIColor(red: 239/255, green: 116/255, blue: 162/255, alpha: 0.4)
        case Blue: // 116,204,239
            return UIColor(red: 116/255, green: 204/255, blue: 239/255, alpha: 0.6)
        case Green: // 116,239,225
            return UIColor(red: 116/255, green: 239/255, blue: 225/255, alpha: 0.6)
        }
    }
    
    static func randomColor() -> UIColor {
        let rand = Int(arc4random_uniform(4) + 1)
        
        if let color = Colors(rawValue: rand) {
            return color.UIColorRepresentation
        }
        else { return UIColor.clearColor() }
    }
}
