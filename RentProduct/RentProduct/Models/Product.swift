//
//  Product.swift
//  RentProduct
//

import Foundation

struct ProductElement: Codable {
    let code, name: String
    let type: TypeEnum
    let availability, needingRepair: Bool
    let durability, maxDurability: Int64
    let mileage: Int64?
    let price: Double
    let minimumRentPeriod: Int64

    enum CodingKeys: String, CodingKey {
        case code, name, type, availability
        case needingRepair = "needing_repair"
        case durability, mileage
        case maxDurability = "max_durability"
        case price
        case minimumRentPeriod = "minimum_rent_period"
    }
}

enum TypeEnum: String, Codable {
    case meter = "meter"
    case plain = "plain"
}

extension ProductElement {
    func convertToCDProduct(cdProduct: CDProduct) -> CDProduct {
        cdProduct.code = self.code
        cdProduct.name = self.name
        cdProduct.type = self.type.rawValue
        cdProduct.availability = self.availability
        cdProduct.needingRepair = self.needingRepair
        cdProduct.durability = self.durability
        cdProduct.maxDurability = self.maxDurability
        cdProduct.mileage = self.mileage ?? 0
        cdProduct.price = self.price
        cdProduct.minimumRentPeriod = self.minimumRentPeriod
        return cdProduct
    }
}
