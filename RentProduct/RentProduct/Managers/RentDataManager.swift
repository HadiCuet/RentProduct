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

    func filterProductsForBook() -> [ProductElement] {
        var products = fetchProducts()

        //1. Filter out not available products
        products = products.filter({ product in
            return product.availability
        })

        //2. Filter out need to repair products
        products = products.filter({ product in
            return !product.needingRepair
        })

        //3. Filter out durability finished products
        products = products.filter({ product in
            return product.durability < product.maxDurability
        })
        Log.info("Data filtered for book - \(products.count)")
        return products
    }

    func filterProductsForReturn() -> [ProductElement] {
        var products = fetchProducts()

        //Filter products that is not available
        products = products.filter({ product in
            return !product.availability
        })
        Log.info("Data filtered for return - \(products.count)")
        return products
    }
}
