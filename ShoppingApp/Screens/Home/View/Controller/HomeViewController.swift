//
//  HomeViewController.swift
//  ShoppingApp
//
//  Created by apple on 27/04/23.
//

import UIKit
import IGListKit

class HomeViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var containerViewLeadingConstraint: NSLayoutConstraint!
    
    lazy var adapter: ListAdapter = {
        let listAdapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self)
        listAdapter.collectionView = collectionView
        listAdapter.dataSource = self
        return listAdapter
    }()
    
    var screenWidth: CGFloat {
        return self.view.bounds.width
    }
    
    var viewModel: HomeViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewModel()
        viewModel?.fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        containerViewLeadingConstraint.constant = -screenWidth
    }
    
    func configureViewModel() {
        let handler: HomeEventsHandler = {[weak self] event in
            switch event {
            case .startLoading:
                LoaderClass.addLoader(self,"Loading...")
            case .stopLoading:
                LoaderClass.hideLoader(self)
            case .reloadCollection:
                DispatchQueue.main.async {
                    self?.adapter.performUpdates(animated: true)
                }
                break
            case .failed(let message):
                self?.showAlert(message: message)
            }
        }
        viewModel = HomeViewModel(eventHandler: handler)
    }
    
    @IBAction func menuAction(button: UIButton) {
        UIView.animate(withDuration: 0.5) {[weak self] in
            self?.containerViewLeadingConstraint.constant = button.tag == 0 ? 0 : -(self?.screenWidth ?? 0.0)
            self?.view.layoutIfNeeded()
        }
    }
    
    @IBAction func logoutAction() {
        UserSession.shared.clearSession()
        UserSession.shared.checkIfUserLoggedIn()
    }

}

extension HomeViewController: ListAdapterDataSource {
    //MARK: - List adapter delegates
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return viewModel?.listDiffable ?? [ListDiffable]()
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        switch object {
        case let obj where obj is String:
            return HomePageListTitleSectionController()
        case let obj where obj is ProductListModel:
            return ProductsCollectionSectionController()
        case let obj where obj is CategoryListModel:
            return EmbededHomeSectionController()
        default:
            return ListSectionController()
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
