//
//  CDProduct+CoreDataProperties.swift
//  RentProduct
//
//  Created by Abdullah Al Hadi on 23/10/22.
//
//

import Foundation
import CoreData


extension CDProduct {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDProduct> {
        return NSFetchRequest<CDProduct>(entityName: "CDProduct")
    }

    @NSManaged public var availability: Bool
    @NSManaged public var code: String
    @NSManaged public var durability: Int64
    @NSManaged public var maxDurability: Int64
    @NSManaged public var mileage: Int64
    @NSManaged public var minimumRentPeriod: Int64
    @NSManaged public var name: String
    @NSManaged public var needingRepair: Bool
    @NSManaged public var price: Double
    @NSManaged public var type: String
    @NSManaged public var rentStartedDate: Date?

}

extension CDProduct : Identifiable {

}
