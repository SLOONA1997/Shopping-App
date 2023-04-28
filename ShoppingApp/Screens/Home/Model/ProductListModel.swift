//
//  ProductListModel.swift
//  ShoppingApp
//
//  Created by apple on 28/04/23.
//

import Foundation
import IGListKit

class ProductListModel: ListDiffable {
    let products: [Product]
    
    let identifier: String
    
    init(products: [Product]) {
        self.products = products
        identifier = UUID().uuidString
    }
    
    //MARK: - List Diffable
    
    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return self === object
    }
}
