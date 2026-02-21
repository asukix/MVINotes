//
//  NoteSummaryState.swift
//  MVINotes
//
//  Created by Seng Phrakonkham on 2026. 02. 05..
//

import Foundation

struct NoteSummaryState {
    var items: [NoteItemDTO] = []
    var filterMode: NotesCategory = .all
    var route: NotesRoute? = nil
    var deletingItems: Set<NoteItemDTO> = []
    var favoritingItemId: UUID? = nil
    
    var filteredItems: [NoteItemDTO] {
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
