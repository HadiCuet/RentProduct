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

    ///Fetch all products from list.
    func getAllProducts() {
        Log.info("Fetch all products.")
        productElements.value = dataManager.fetchProducts()
    }

    ///Search a product by it's name.
    func searchProducts(withString query: String) {
        Log.info("Search product with key - \(query)")
        productElements.value = dataManager.searchProduct(withKey: query)
    }

    ///Return product count those are available for booking
    func getBookProductCount() -> Int {
        Log.info("Product count for booking")
        return dataManager.filterProductsForBook().count
    }

    ///Return product count those are available to return.
    func getReturnProductCount() -> Int {
        Log.info("Product count for returning.")
        return dataManager.filterProductsForReturn().count
    }

    ///Fetch  products those are available for booking.
    func getProductsForBook() {
        Log.info("Filtering product for booking")
        filteredProducts.value = dataManager.filterProductsForBook()
    }

    ///Return estimated price for the product with end date.
    func getEstimatedPrice(forProduct product: ProductElement, till: Date) -> Double {
        let totalDay = Calendar.current.numberOfDaysBetween(Date(), and: till)
        let price = product.price * Double(totalDay)
        Log.info("Total estimated price - \(price) for product - \(product.code)")
        return price
    }

    ///Confirm product to book.
    func bookProductForRent(_ product: ProductElement?) {
        if var updatedProduct = product {
            updatedProduct.availability = false
            updatedProduct.rentStartedDate = Date()
            let updated = dataManager.updateProduct(updatedProduct)
            Log.info("Update product done - \(updated)")
        }
    }

    ///Fetch  products those are available to return.
    func getProductsForReturn() {
        Log.info("Filtering product to return.")
        filteredProducts.value = dataManager.filterProductsForReturn()
    }

    ///Return total rent price for the product.
    func getReturnPrice(forProduct product: ProductElement) -> Double {
        let rentPeriod = getRentPeriod(forProduct: product)
        let price = product.price * Double(rentPeriod)
        Log.info("Total rent price - \(price) for product - \(product.code)")
        return price
    }

    private func getRentPeriod(forProduct product: ProductElement) -> Int {
        if let startDate = product.rentStartedDate {
            var totalDay = Calendar.current.numberOfDaysBetween(startDate, and: Date())
            if totalDay < product.minimumRentPeriod {
                totalDay = Int(product.minimumRentPeriod)
            }
            Log.info("Total rent period - \(totalDay) from - \(startDate)")
            return totalDay
        }
        Log.error("Product rent start date not found - \(product.minimumRentPeriod)")
        return Int(product.minimumRentPeriod)
    }

    ///Confirm product is returned.
    func returnProduct(_ product: ProductElement?, mileage: Int64?, needToRepair: Bool) {
        guard var product = product else {
            Log.error("Return product item is nil.")
            return
        }
        Log.info("Return product - \(product.code), Repair - \(needToRepair), mileage used - \(String(describing: mileage))")
        product.availability = true
        product.needingRepair = needToRepair
        product.rentStartedDate = nil
        let rentPeriod = Int64(self.getRentPeriod(forProduct: product))

        if product.type == .plain {
            //Durability decrease 1 point par day
            product.durability += rentPeriod
        }
        else {
            //Durability decrease 2 points par day
            product.durability += (2 * rentPeriod)
            if let mileage = mileage {
                //Add used mileage.
                product.mileage = (product.mileage ?? 0) + mileage

                //Durability decrease 1 points par 5 mileage use.
                product.durability += (mileage / 5)
            }
        }
        let updated = dataManager.updateProduct(product)
        Log.info("Update return product done - \(updated)")
    }
}
