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
        // Keresd meg a modellt a megfelelő bundle-ben
        let bundles = [Bundle.main, Bundle(for: NoteItem.self)]
        var modelURL: URL?
        
        for bundle in bundles {
            if let url = bundle.url(forResource: "MVINotes", withExtension: "momd") {
                modelURL = url
                break
            }
        }
        
        guard let url = modelURL,
              let model = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Failed to load Core Data model")
        }
        
        let container = NSPersistentContainer(name: "MVINotes", managedObjectModel: model)
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
