//
//  HomeViewModel.swift
//  RentProduct
//

import Foundation

protocol HomeViewModelProtocol {
    var productElements: Bindable<[ProductElement]> { get }
    func searchProducts(withString query: String)
}

class HomeViewModel: NSObject, HomeViewModelProtocol {
    var productElements: Bindable<[ProductElement]> = Bindable([])

    private let dataManager : RentDataManager

    override init() {
        dataManager = RentDataManager()
        super.init()
    }

    func getAllProducts() {
        productElements.value = dataManager.fetchProducts()
    }

    func searchProducts(withString query: String) {
        Log.info("Search product with key - \(query)")
        productElements.value = dataManager.searchProduct(withKey: query)
    }
}
