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
    func updateProduce(product: ProductElement) -> Bool
}

struct ProductDataRepository : ProductRepository {
    func createProduct(product: ProductElement) {
        var cdProduct = CDProduct(context: PersistentStorage.shared.context)
//        cdProduct.code = product.code
//        cdProduct.name = product.name
//        cdProduct.type = product.type.rawValue
//        cdProduct.availability = product.availability
//        cdProduct.needingRepair = product.needingRepair
//        cdProduct.durability = product.durability
//        cdProduct.maxDurability = product.maxDurability
//        cdProduct.mileage = product.mileage ?? 0
//        cdProduct.price = product.price
//        cdProduct.minimumRentPeriod = product.minimumRentPeriod
        cdProduct = product.convertToCDProduct(cdProduct: cdProduct)

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

    func updateProduce(product: ProductElement) -> Bool {
        guard var cdProduct = getCDProduct(byCode: product.code) else {
            Log.error("Product not found to update - \(product.code)")
            return false
        }
        cdProduct = product.convertToCDProduct(cdProduct: cdProduct)
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
