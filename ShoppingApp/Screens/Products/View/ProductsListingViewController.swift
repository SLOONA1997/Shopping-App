//
//  ProductsListingViewController.swift
//  ShoppingApp
//
//  Created by apple on 29/04/23.
//

import UIKit
import IGListKit

class ProductsListingViewController: UIViewController, ListAdapterDataSource {
    
    //MARK: - Outlets
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private lazy var adapter: ListAdapter = {
        let listAdapter = ListAdapter.init(updater: ListAdapterUpdater(), viewController: self)
        listAdapter.dataSource = self
        listAdapter.collectionView = collectionView
        listAdapter.scrollViewDelegate = self
        return listAdapter
    }()
    
    lazy var viewModel: ProductsListViewModel = {
        configureVMListners()
        let vm = ProductsListViewModel(eventHandler: handler!)
        return vm
    }()
    
    private var handler: ProductsListVMEventsHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateUI()
        viewModel.fetchProducts()
    }
    
    //Must be called before VM setup
    func configureVMListners() {
        self.handler = {[weak self] event in
            guard let self = self else { return }
            switch event {
            case .startLoading:
                LoaderClass.addLoader(self,"Loading...")
            case .stopLoading:
                LoaderClass.hideLoader(self)
            case .fetchedNewProducts:
                DispatchQueue.main.async {[weak self] in
                    self?.adapter.performUpdates(animated: true)
                }
            case .failed(let message):
                self.showAlert(message: message)
            }
        }
    }
    
    func populateUI() {
        titleLbl.text = viewModel.title
    }
}

extension ProductsListingViewController: UIScrollViewDelegate {
    //MARK: - Adatpter Data source
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return viewModel.listDiffableDataSource
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if let object = object as? String, object == viewModel.spinnerObj {
            return spinnerSectionController()
        } else {
            return ProductsCollectionSectionController()
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
    // MARK: UIScrollViewDelegate

    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard viewModel.isPendingProducts else { return }

        let distance = scrollView.contentSize.height - (targetContentOffset.pointee.y + scrollView.bounds.height)
        if !viewModel.isLoading && distance < 200 {
            viewModel.fetchProducts()
            DispatchQueue.main.async {[weak self] in
                self?.adapter.performUpdates(animated: true, completion: nil)
            }
            
        }
    }
}
