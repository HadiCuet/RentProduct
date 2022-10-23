//
//  ProductDataRepository.swift
//  RentProduct
//

import Foundation
import CoreData

protocol ProductRepository {
    func createProduct(product: ProductElement)
    func getAllProduct() -> [ProductElement]?
    func getProduct(byCode code: String) -> ProductElement?
    func updateProduct(product: ProductElement) -> Bool
}

struct ProductDataRepository : ProductRepository {

    func createOrUpdateProduct(_ product: ProductElement) {
        if self.getCDProduct(byCode: product.code) == nil {
            self.createProduct(product: product)
        }
        else {
            _ = self.updateProduct(product: product)
        }
    }

    func createProduct(product: ProductElement) {
        var cdProduct = CDProduct(context: PersistentStorage.shared.context)
        product.convertToCDProduct(&cdProduct)

        PersistentStorage.shared.saveContext()
    }

    func getAllProduct() -> [ProductElement]? {
        let result = PersistentStorage.shared.fetchManagedObject(object: CDProduct.self)

        var products = [ProductElement]()

        result?.forEach({ (cdProduct) in
            products.append(cdProduct.convertToProduct())
        })
        return products
    }

    func getProduct(byCode code: String) -> ProductElement? {
        guard let cdProduct = getCDProduct(byCode: code) else {
            Log.error("Get product by id - \(code) - is not found")
            return nil
        }
        Log.info("Get product by id - \(code) - found")
        return cdProduct.convertToProduct()
    }

    func updateProduct(product: ProductElement) -> Bool {
        guard var cdProduct = getCDProduct(byCode: product.code) else {
            Log.error("Product not found to update - \(product.code)")
            return false
        }
        product.convertToCDProduct(&cdProduct)
        PersistentStorage.shared.saveContext()

        Log.info("Product update successful.")
        return true
    }

    private func getCDProduct(byCode code: String) -> CDProduct? {
        let fetchRequest = NSFetchRequest<CDProduct>(entityName: "CDProduct")
        let predicate = NSPredicate(format: "code==%@", code as CVarArg)
        fetchRequest.predicate = predicate

        do {
            return try PersistentStorage.shared.context.fetch(fetchRequest).first
        }
        catch let error {
            Log.error("Exception on fetch request - \(error.localizedDescription)")
        }
        return nil
    }
}
