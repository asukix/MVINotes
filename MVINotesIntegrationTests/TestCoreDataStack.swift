//
//  TestCoreDataStack.swift
//  MVINotes
//
//  Created by Phrakonkham Sengpraseuth on 2026. 03. 08..
//

import CoreData
@testable import MVINotes

enum TestCoreDataStack {
    static func makeContext() -> NSManagedObjectContext {
        let container = NSPersistentContainer(name: "MVINotes")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        return container.viewContext
    }
}
