//
//  AppUtility.swift
//  ShoppingApp
//
//  Created by apple on 28/04/23.
//

import UIKit

class AppUtility {
    class func getRandomColorForOverlay() -> UIColor {
        let colorsList: [UIColor] = [.green,.red,.blue,.black,.brown,.gray,.magenta,.orange,.purple,.cyan]
        return colorsList.randomElement()?.withAlphaComponent(0.6) ?? UIColor.clear
    }
}
