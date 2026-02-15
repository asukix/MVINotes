//
//  NoteSummaryState.swift
//  MVINotes
//
//  Created by Seng Phrakonkham on 2026. 02. 05..
//

import Foundation

struct NoteSummaryState {
    var items: [NoteSummaryDTO] = [
        NoteSummaryDTO(
            title: "Practice MVI",
            summary: "Summary 1",
            date: Date(),
            category: .favorites
        ),
        NoteSummaryDTO(
            title: "Practice CoreData",
            summary: "Summary 2",
            date: Date(),
            category: .none
        ),
        NoteSummaryDTO(
            title: "Practice MVVM",
            summary: "Summary 3",
            date: Date(),
            category: .none
        )
    ]
    var filterMode: NoteCategory = .all
    var route: NotesRoute? = nil
    
    var filteredItems: [NoteSummaryDTO] {
        switch filterMode {
        case .all:
            return items
        case .none:
            return items.filter( { $0.category == .none } )
        case .favorites:
            return items.filter( { $0.category == .favorites } )
        }
    }
}
