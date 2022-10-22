//
//  InitDataManager.swift
//  RentProduct
//

import Foundation

class InitDataManager {

    let jsonFileName = "backend-frontend-data"
    let jsonFileFormat = "json"
    let dataSaveDoneKey = "DataSaveDoneKey"

    func setInitData() {
        guard !isDataSaveDone() else {
            Log.info("Init data already seved to storage.")
            return
        }
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
        UserDefaults.standard.set(true, forKey: dataSaveDoneKey)
    }
}
