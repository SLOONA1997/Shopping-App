//
//  HomePageListTitleSectionController.swift
//  ShoppingApp
//
//  Created by apple on 28/04/23.
//

import UIKit
import IGListKit

class HomePageListTitleSectionController: ListSectionController {
    
    private var title: String?
    
    var seeAllCallBack: ((Int?)-> ())?
    
    override func didUpdate(to object: Any) {
        self.title = object as? String
        
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell: HomeCollectionHeaderCell = collectionContext?.dequeueReusableCellFromStoryboard(withIdentifier: "HomeCollectionHeaderCell", for: self, at: index) as! HomeCollectionHeaderCell
        cell.title = title ?? "N/A"
        cell.seeAllBtn?.isHidden = title == "Categories"
        cell.seeAllCallBack = seeAllCallBack
        return cell
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize.init(width: collectionContext?.containerSize.width ?? 0.0, height: 60.0)
    }
}
