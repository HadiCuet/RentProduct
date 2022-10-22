//
//  HomeViewModel.swift
//  RentProduct
//

import Foundation
import UIKit

protocol HomeViewModelProtocol {
    var productElements: Bindable<[ProductElement]> { get }
//    func searchMovie(withQueryString query: String?)
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
}
