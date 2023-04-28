//
//  EmbededHomeSectionController.swift
//  ShoppingApp
//
//  Created by apple on 28/04/23.
//

import UIKit
import IGListKit

class EmbededHomeSectionController: ListSectionController, ListAdapterDataSource {
    
    private var model: CategoryListModel?
    
    lazy var adapter: ListAdapter = {
        let listAdapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self.viewController)
        listAdapter.dataSource = self
        return listAdapter
    }()
    
    //MARK: - Collection Delegates
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = self.collectionContext?.dequeueReusableCellFromStoryboard(withIdentifier: CategoriesContainerCollectionCell.className, for: self, at: index) as! CategoriesContainerCollectionCell
        adapter.collectionView = cell.collectionView
        return cell
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize.init(width: collectionContext?.containerSize.width ?? 0.0, height: 116)
    }
    
    
    //MARK: - List adapter Data sources
    override func didUpdate(to object: Any) {
        self.model = object as? CategoryListModel
    }
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        guard let model = model else {
            return [ListDiffable]()
        }
        return [model]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return CategoriesSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
