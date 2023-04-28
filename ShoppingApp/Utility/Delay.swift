//
//  Delay.swift
//  ShoppingApp
//
//  Created by apple on 27/04/23.
//

import Foundation

class Delay {
    class func delay(_ seconds: Double,_ callback:@escaping ()->Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            callback()
        }
    }
}
