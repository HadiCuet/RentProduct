//
//  PersistentStorage.swift
//  RentProduct
//

import Foundation
import CoreData

class PersistentStorage: NSObject {
    private override init() {
        super.init()
    }
    static let shared = PersistentStorage()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RentProduct")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
