//
//  CategoryListModel.swift
//  ShoppingApp
//
//  Created by apple on 28/04/23.
//

import Foundation
import IGListKit

class CategoryListModel: ListDiffable {
    let categories: [Category]
    
    private var identifier: String
    
    init(categories: [Category]) {
        self.categories = categories
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
