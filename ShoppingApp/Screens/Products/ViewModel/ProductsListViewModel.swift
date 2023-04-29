//
//  ProductsListViewModel.swift
//  ShoppingApp
//
//  Created by apple on 29/04/23.
//

import Foundation
import IGListKit

enum ProductsListVMEvent {
    case startLoading
    case stopLoading
    case fetchedNewProducts
    case failed(message: String)
}

typealias ProductsListVMEventsHandler = (ProductsListVMEvent) ->()

class ProductsListViewModel {
    
    let spinnerObj: String = "Spinner"
    let paginationLimit: Int = 10
    
    var category: Category?
    private var products: [Product]
    
    var title: String {
        return category?.name ?? "All Products"
    }
    
    var listDiffableDataSource: [ListDiffable] {
        var objs = [ProductListModel(products: products)] as [ListDiffable]
        if isLoading {
            objs.append(spinnerObj as ListDiffable)
        }
        return objs
    }
    
    var isPendingProducts = true
    
    var isLoading = false {
        willSet {
            if products.isEmpty, newValue == false {
                eventHandler(.stopLoading)
            }
        }
        didSet {
            if isLoading && products.isEmpty {
                eventHandler(.startLoading)
            }
        }
    }
    
    var eventHandler: ProductsListVMEventsHandler
    
    init(eventHandler:@escaping ProductsListVMEventsHandler) {
        self.eventHandler = eventHandler
        products = [Product]()
    }
    
    private func getFilters() -> ProductFilterModel {
        var filters = ProductFilterModel()
        filters.categoryId = category?.id
        filters.offset = products.count
        filters.limit = paginationLimit
        return filters
    }
    
    func fetchProducts() {
        guard isPendingProducts else { return }
        let filters = getFilters()
        isLoading = true
        APIManager.serverRequest(modelType: [Product].self,
                                 apiType: .products(filter: filters)) {[weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let fetchedProducts):
                self.products.append(contentsOf: fetchedProducts)
                if fetchedProducts.count < self.paginationLimit {
                    self.isPendingProducts = false
                }
                self.eventHandler(.fetchedNewProducts)
            case .failure(let error):
                self.eventHandler(.failed(message: error.localizedDescription))
            }
        }
    }
    
}
