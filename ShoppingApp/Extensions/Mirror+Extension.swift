//
//  Mirror+Extension.swift
//  ShoppingApp
//
//  Created by apple on 27/04/23.
//

import Foundation

extension Mirror {
    func getDict() -> [String: Any?] {
        let json = children.reduce(into: [String: Any?]()) { partialResult, instance in
            if let key = instance.label, case Optional<Any>.some(let value) = instance.value {
                partialResult[key] = value
            }
        }
        return json
    }
}
