//
//  InitProduct.swift
//  RentProduct
//

import Foundation

struct InitProductElement: Codable {
    let code, name: String
    let type: TypeEnum
    let availability, needingRepair: Bool
    let durability, maxDurability: Int
    let mileage: Int?
    let price, minimumRentPeriod: Int

    enum CodingKeys: String, CodingKey {
        case code, name, type, availability
        case needingRepair = "needing_repair"
        case durability
        case maxDurability = "max_durability"
        case mileage, price
        case minimumRentPeriod = "minimum_rent_period"
    }
}

enum TypeEnum: String, Codable {
    case meter = "meter"
    case plain = "plain"
}
