//
//  Array+Extension.swift
//  ShoppingApp
//
//  Created by apple on 28/04/23.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        if 0..<count ~= index {
            return self[index]
        }
        return nil
    }
}
