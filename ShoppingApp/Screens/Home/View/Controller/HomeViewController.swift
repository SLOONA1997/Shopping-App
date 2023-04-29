//
//  HomeViewController.swift
//  ShoppingApp
//
//  Created by apple on 27/04/23.
//

import UIKit
import IGListKit

typealias HomeToProductListingHandler = (Int?)->()

class HomeViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var containerViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuCrossbtn: UIButton!
    
    lazy var adapter: ListAdapter = {
        let listAdapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self)
        listAdapter.collectionView = collectionView
        listAdapter.dataSource = self
        return listAdapter
    }()
    
    var homeToProductsListingHandler: HomeToProductListingHandler?
    
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
        
        //Handler for Home to products listing transition
        homeToProductsListingHandler = {[weak self] selectedIndex in
            guard let self = self else { return }
            let category: Category?
            if let selectedIndex = selectedIndex {
                category = self.viewModel?.categories?[safe: selectedIndex]
            } else {
                category = nil
            }
            self.performSegue(withIdentifier: "HomeToProductsList", sender: category)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let category = sender as? Category, let destVc = segue.destination as? ProductsListingViewController {
            destVc.viewModel.category = category
        }
    }
    
    @IBAction func menuAction(button: UIButton) {
        UIView.animate(withDuration: 0.5) {[weak self] in
            self?.containerViewLeadingConstraint.constant = button.tag == 0 ? 0 : -(self?.screenWidth ?? 0.0)
            self?.view.layoutIfNeeded()
        }
    }
    
    @IBAction func menuOptionClicked(button: UIButton) {
        guard let type = MenuType(rawValue: button.tag) else {
            return
        }
        switch type {
        case .home:
            menuAction(button: menuCrossbtn)
        case .logout:
            showActionsheet(title: "Log Out", message: "Are you sure you want to logout?", buttons: ["Cancel","LogOut"]) { selectedIndex in
                if selectedIndex == 1 {
                    UserSession.shared.clearSession()
                    UserSession.shared.checkIfUserLoggedIn()
                }
            }
        default:
            showAlert(message: "Feature coming soon")
        }
        
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
            let homePageTitleSection = HomePageListTitleSectionController()
            homePageTitleSection.seeAllCallBack = homeToProductsListingHandler
            return homePageTitleSection
        case let obj where obj is ProductListModel:
            return ProductsCollectionSectionController()
        case let obj where obj is CategoryListModel:
            return EmbededHomeSectionController(callback: homeToProductsListingHandler)
        default:
            return ListSectionController()
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
