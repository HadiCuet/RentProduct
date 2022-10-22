//
//  ProductTableViewCell.swift
//  RentProduct
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var availableLabel: UILabel!
    @IBOutlet weak var repairLabel: UILabel!
    @IBOutlet weak var durabilityLabel: UILabel!
    @IBOutlet weak var mileageLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setProductData(_ product: ProductElement) {
        self.nameLabel.text = product.name
        self.codeLabel.text = "Product code: " + product.code
        self.availableLabel.text = "Availability: " + (product.availability ? "Yes" : "No")
        self.repairLabel.text = "Need to repair: " + (product.needingRepair ? "Yes" : "No")
        self.durabilityLabel.text = "Durability: " + "\(product.durability)/\(product.maxDurability)"
        self.mileageLabel.text = ""
        if let mileage = product.mileage, mileage != -1 {
            self.mileageLabel.text = "Mileage: " + "\(mileage)"
        }
    }
}
