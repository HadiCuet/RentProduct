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

    func getBookProductCount() -> Int {
        return dataManager.filterProductsForBook().count
    }

    func getReturnProductCount() -> Int {
        return dataManager.filterProductsForReturn().count
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
        let rentPeriod = getRentPeriod(forProduct: product)
        return product.price * Double(rentPeriod)
    }

    private func getRentPeriod(forProduct product: ProductElement) -> Int {
        if let startDate = product.rentStartedDate {
            var totalDay = Calendar.current.numberOfDaysBetween(startDate, and: Date())
            if totalDay < product.minimumRentPeriod {
                totalDay = Int(product.minimumRentPeriod)
            }
            return totalDay
        }
        return Int(product.minimumRentPeriod)
    }

    func returnProduct(_ product: ProductElement?, mileage: Int64?, needToRepair: Bool) {
        guard var product = product else {
            return
        }
        product.availability = true
        product.needingRepair = needToRepair
        product.rentStartedDate = nil
        let rentPeriod = Int64(self.getRentPeriod(forProduct: product))

        if product.type == .plain {
            product.durability += rentPeriod
        }
        else {
            product.durability += (2 * rentPeriod)
            if let mileage = mileage {
                product.mileage = (product.mileage ?? 0) + mileage
                product.durability += (mileage / 5)
            }
        }
        let updated = dataManager.updateProduct(product)
        Log.info("Update return product done - \(updated)")
    }
}
