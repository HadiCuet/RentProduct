//
//  InitDataManager.swift
//  RentProduct
//

import Foundation

struct InitDataManager {

    let jsonFileName = "backend-frontend-data"
    let jsonFileFormat = "json"
    let dataSaveDoneKey = "DataSaveDoneKey"

    func setInitData() {
        guard !isDataSaveDone() else {
            Log.info("Init data already saved to storage.")
            return
        }
        Log.info("Init data not saved yet.")
        let initProducts = readDataFromJson()
        self.saveDataToStorage(initProducts)
    }

    private func isDataSaveDone() -> Bool {
        return UserDefaults.standard.bool(forKey: dataSaveDoneKey)
    }

    private func readDataFromJson() -> [ProductElement] {
        var products = [ProductElement]()

        guard let bundlePath = Bundle.main.path(forResource: jsonFileName, ofType: jsonFileFormat) else {
            Log.error("Couldn't find json path")
            return products
        }
        do {
            if let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                products = try JSONDecoder().decode([ProductElement].self, from: jsonData)
                Log.info("Json docode success")
            }
        }
        catch let error {
            Log.error("Error on parsing json - \(error.localizedDescription)")
        }
        return products
    }

    private func saveDataToStorage(_ products : [ProductElement]) {
        let productRepository = ProductDataRepository()
        products.forEach({ (product) in
            var newProduct = product
            if !newProduct.availability {
                newProduct.rentStartedDate = Date()
            }
            productRepository.createOrUpdateProduct(newProduct)
        })
        Log.info("All init data saved to core data.")
        UserDefaults.standard.set(true, forKey: dataSaveDoneKey)
    }
}
