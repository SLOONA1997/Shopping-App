//
//  NSObject+Extension.swift
//  ShoppingApp
//
//  Created by apple on 28/04/23.
//

import Foundation

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}
