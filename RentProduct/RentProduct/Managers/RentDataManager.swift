//
//  RentDataManager.swift
//  RentProduct
//

import Foundation

struct RentDataManager {

    private let productRepository = ProductDataRepository()

    func fetchProducts() -> [ProductElement] {
        return self.productRepository.getAllProduct() ?? []
    }

    func getProduct(byCode code: String) -> ProductElement? {
        return self.productRepository.getProduct(byCode: code)
    }

    func updateProduct(_ product: ProductElement) -> Bool {
        return self.productRepository.updateProduct(product: product)
    }

    func searchProduct(withKey text : String) -> [ProductElement] {
        var products = fetchProducts()

        products = products.filter({ product in
            return product.name.lowercased().contains(text.lowercased())
        })
        Log.info("Data filtered count - \(products.count)")
        return products
    }
}
