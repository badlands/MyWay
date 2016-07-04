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
//    case Violet = 1, Pink, Blue, Green, 
    case AzulRey = 1, MB3, Confront, DarkNotSoLightBlue
    case Yellowish

    var UIColorRepresentation : UIColor {
        switch self {
//        case Violet:
//            return UIColor(red: 229/255, green: 94/255, blue: 170/255, alpha: 0.4)
//        case Pink: // 239,116,162
//            return UIColor(red: 239/255, green: 116/255, blue: 162/255, alpha: 0.4)
//        case Blue: // 116,204,239
//            return UIColor(red: 116/255, green: 204/255, blue: 239/255, alpha: 0.6)
//        case Green: // 116,239,225
//            return UIColor(red: 116/255, green: 239/255, blue: 225/255, alpha: 0.6)
        case AzulRey: // 46,46,211
            return UIColor(red: 46/255, green: 46/255, blue: 211/255, alpha: 1)
        case MB3:
            return UIColor(red: 37/255, green: 111/255, blue: 209/255, alpha: 1)
        case .Confront:
            return UIColor(red: 53/255, green: 81/255, blue: 191/255, alpha: 1)
        case .DarkNotSoLightBlue:
            return UIColor(red: 41/255, green: 140/255, blue: 216/255, alpha: 1)
        case .Yellowish:
            return UIColor(red: 224/255, green: 157/255, blue: 8/255, alpha: 1)
//        default:
//            return UIColor.clearColor()
        }
    }
}

class ColorPalette {
    static func randomColor() -> UIColor {
        let rand = Int(arc4random_uniform(4) + 1)
        
        if let color = Colors(rawValue: rand) {
            return color.UIColorRepresentation
        }
        else { return UIColor.clearColor() }
    }
}
