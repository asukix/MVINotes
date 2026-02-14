//
//  NoteListReducer.swift
//  MVINotes
//
//  Created by Seng Phrakonkham on 2026. 02. 11..
//
import Foundation

struct NoteListReducer {
    func reduce(state: inout NoteSummaryState, action: NotesAction) {
        switch action {
        case .filter(let category):
            state.filterMode = category
        case .delete(let id):
            state.items.removeAll { $0.id == id }
        case .markAsFavoriteUnFavorite(let id):
            markAsFavorite(id: id, state: &state)
        case .addTapped:
            state.route = .addNote
        case .addCanncelled:
            state.route = nil
        case .addSaved(let item):
            state.items.insert(item, at: 0)
            state.route = nil
        default:
            break
        }
        
    }
    
    private func markAsFavorite(id: UUID, state: inout NoteSummaryState) {
        guard let idx = state.items.firstIndex(where: { $0.id == id }) else {
            return
        }
        
        let isFavorite = state.items[idx].category == NoteCategory.favorites
        state.items[idx].category = isFavorite ? .none : NoteCategory.favorites
    }
}
