//
//  Extension+CDProducts.swift
//  RentProduct
//

import Foundation

extension CDProduct {
    func convertToProduct() -> ProductElement {
        return ProductElement(code: self.code,
                              name: self.name,
                              type: TypeEnum(rawValue: self.type) ?? TypeEnum.plain,
                              availability: self.availability,
                              needingRepair: self.needingRepair,
                              durability: self.durability,
                              maxDurability: self.maxDurability,
                              mileage: self.mileage,
                              price: self.price,
                              minimumRentPeriod: self.minimumRentPeriod)
    }
}
