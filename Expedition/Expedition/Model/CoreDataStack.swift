//
//  CoreDataStack.swift
//  Expedition
//
//  Created by Luis Alfonso Arriaga Quezada on 14/12/21.
//

import Foundation
import CoreData

enum CoreDataStack {
    static var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "Expedition")
        container.loadPersistentStores { (persistenStoreDesc, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    static var context: NSManagedObjectContext {return persistentContainer.viewContext}
    static func saveToPersistenStorage() {
        do {
            try persistentContainer.viewContext.save()
            print("Saved succesfully to persistent storage cloud/local")
        } catch {
            print(error)
        }
    }
}
