//
//  MVINotesApp.swift
//  MVINotes
//
//  Created by Seng Phrakonkham on 2026. 02. 02..
//

import SwiftUI
import CoreData

@main
struct MVINotesApp: App {
    let persistenceController = PersistenceController.shared
    
    var repository: NotesRepositoryProtocol {
        NotesRepository(context: persistenceController.container.viewContext)
    }

    var body: some Scene {
        WindowGroup {
            NotesListView(store: NotesStore(repository: repository))
                .environment(
                    \.managedObjectContext,
                     persistenceController.container.viewContext
                )
        }
    }
}
