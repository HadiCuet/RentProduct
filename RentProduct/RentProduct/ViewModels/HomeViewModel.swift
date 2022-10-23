//
//  HomeViewModel.swift
//  RentProduct
//

import Foundation

protocol HomeViewModelProtocol {
    var productElements: Bindable<[ProductElement]> { get }
    var filteredProducts: Bindable<[ProductElement]> { get }
    func searchProducts(withString query: String)
}

class HomeViewModel: NSObject, HomeViewModelProtocol {
    var productElements: Bindable<[ProductElement]> = Bindable([])
    var filteredProducts: Bindable<[ProductElement]> = Bindable([])

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

    func getProductsForBook() {
        filteredProducts.value = dataManager.filterProductsForBook()
    }

    func getEstimatedPrice(forProduct product: ProductElement, till: Date) -> Double {
        let totalDay = Calendar.current.numberOfDaysBetween(Date(), and: till)
        return product.price * Double(totalDay)
    }

    func bookProductForRent(_ product: ProductElement?) {
        if var updatedProduct = product {
            updatedProduct.availability = false
            updatedProduct.rentStartedDate = Date()
            let updated = dataManager.updateProduct(updatedProduct)
            Log.info("Update product done - \(updated)")
        }
    }

    func getProductsForReturn() {
        filteredProducts.value = dataManager.filterProductsForReturn()
    }

    func getReturnPrice(forProduct product: ProductElement) -> Double {
        if let startDate = product.rentStartedDate {
            var totalDay = Calendar.current.numberOfDaysBetween(startDate, and: Date())
            if totalDay < product.minimumRentPeriod {
                totalDay = Int(product.minimumRentPeriod)
            }
            return product.price * Double(totalDay)
        }
        return product.price * Double(product.minimumRentPeriod)
    }

    func returnProduct(_ product: ProductElement?, mileage: Int64?, needToRepair: Bool) {
        
    }
}
