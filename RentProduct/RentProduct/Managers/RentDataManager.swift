//
//  RentDataManager.swift
//  RentProduct
//

import Foundation

struct RentDataManager {

    private let productRepository = ProductDataRepository()

    func fetchProducts() -> [ProductElement] {
        self.productRepository.getAllProduct() ?? []
    }

    func getProduct(byCode code: String) -> ProductElement? {
        return self.productRepository.getProduct(byCode: code)
    }

    func updateProduct(_ product: ProductElement) -> Bool {
        return self.productRepository.updateProduct(product: product)
    }
}
