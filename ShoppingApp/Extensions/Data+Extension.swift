//
//  Data+Extension.swift
//  ShoppingApp
//
//  Created by apple on 26/04/23.
//

import Foundation

extension Data {
   mutating func append(_ string: String) {
      if let data = string.data(using: .utf8) {
         append(data)
         print("data======>>>",data)
      }
   }
}
