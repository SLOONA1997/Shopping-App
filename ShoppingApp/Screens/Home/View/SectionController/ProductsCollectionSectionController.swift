//
//  ProductsCollectionSectionController.swift
//  ShoppingApp
//
//  Created by apple on 28/04/23.
//

import Foundation
import IGListKit

class ProductsCollectionSectionController: ListSectionController {
    
    private var products = [Product]()
    
    override init() {
        super.init()
        inset = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    override func didUpdate(to object: Any) {
        if let products = (object as? ProductListModel)?.products {
            self.products = products
        }
    }
    
    override func numberOfItems() -> Int {
        return products.count
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext?.dequeueReusableCellFromStoryboard(withIdentifier: ProductCollectionCell.className, for: self, at: index) as! ProductCollectionCell
        if let product = products[safe: index] {
            cell.configure(model: product)
        }
        return cell
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let containerWithWithoutSpacing = (collectionContext?.containerSize.width ?? 0.0) - 30
        let width = containerWithWithoutSpacing / 2
        let height = 1.521 * width
        return .init(width: width, height: height)
    }
}
