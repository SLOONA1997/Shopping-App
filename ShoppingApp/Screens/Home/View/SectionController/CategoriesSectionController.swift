//
//  CategoriesSectionController.swift
//  ShoppingApp
//
//  Created by apple on 28/04/23.
//

import UIKit
import IGListKit

class CategoriesSectionController: ListSectionController {
    
    private var categories: [Category]?
    
    override init() {
        super.init()
        inset = .init(top: 0, left: 20, bottom: 0, right: 0)
    }
    
    //MARK: - List adapter delegates
    
    override func didUpdate(to object: Any) {
        self.categories = (object as? CategoryListModel)?.categories
    }
    
    override func numberOfItems() -> Int {
        return categories?.count ?? 0
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCellFromStoryboard(withIdentifier: CategoryCollectionCell.className, for: self, at: index) as! CategoryCollectionCell
        if let category = categories?[safe: index] {
            cell.configure(model: category)
        }
        return cell
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let height = (collectionContext?.containerSize.height ?? 0.0)
        let width = (collectionContext?.containerSize.width ?? 0.0) * 0.4
        return .init(width: width, height: height)
    }
}
