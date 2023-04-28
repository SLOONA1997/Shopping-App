//
//  HomeViewModel.swift
//  ShoppingApp
//
//  Created by apple on 27/04/23.
//

import Foundation
import IGListKit

enum HomeVMEvent {
    case startLoading
    case stopLoading
    case reloadCollection
    case failed(String)
}

typealias HomeEventsHandler = (HomeVMEvent) -> ()

class HomeViewModel {
    
    var categories: [Category]? {
        didSet {
            eventHandler(.reloadCollection)
        }
    }
    var products: [Product]? {
        didSet {
            eventHandler(.reloadCollection)
        }
    }
    
    var listDiffable: [ListDiffable]? {
        guard let categories = categories,let products = products else {
            return nil
        }
        return ["Categories",
                CategoryListModel(categories: categories),
                "Products",
                ProductListModel(products: products)] as? [any ListDiffable]
    }
    
    let eventHandler: HomeEventsHandler
    
    init(eventHandler: @escaping HomeEventsHandler) {
        self.eventHandler = eventHandler
    }
    
    func fetchData() {
        eventHandler(.startLoading)
        fetchCategories()
        fetchProducts()
    }
    
    private func fetchCategories() {
        APIManager.serverRequest(modelType: [Category].self,
                                 apiType: .categories) {[weak self] result in
            self?.eventHandler(.stopLoading)
            switch result {
            case .success(let categories):
                self?.categories = categories
            case .failure(let error):
                self?.eventHandler(.failed(error.localizedDescription))
            }
        }
    }
    
    private func fetchProducts() {
        let filter = ProductFilterModel(offset: 0,limit: 10)
        APIManager.serverRequest(modelType: [Product].self,
                                 apiType: .products(filter: filter)) {[weak self] result in
            self?.eventHandler(.stopLoading)
            switch result {
            case .success(let products):
                self?.products = products
            case .failure(let error):
                self?.eventHandler(.failed(error.localizedDescription))
            }
        }
    }
}
