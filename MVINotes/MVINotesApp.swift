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

    var body: some Scene {
        WindowGroup {
            NotesListView()
        }
    }
}
