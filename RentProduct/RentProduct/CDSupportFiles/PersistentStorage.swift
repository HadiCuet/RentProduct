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

    lazy var context = persistentContainer.viewContext

    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func fetchManagedObject<T: NSManagedObject>(object: T.Type) -> [T]? {
        do {
            guard let result = try context.fetch(object.fetchRequest()) as? [T] else {
                Log.error("Error on fetch object.")
                return nil
            }
            return result
        }
        catch let error {
            Log.error("Exception on fetch object - \(error.localizedDescription)")
        }
        return nil
    }
}
