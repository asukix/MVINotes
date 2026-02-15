//
//  NoteListReducer.swift
//  MVINotes
//
//  Created by Seng Phrakonkham on 2026. 02. 11..
//
import Foundation

struct NoteListReducer {
    let repository: NotesRepositoryProtocol
    
    func reduce(state: inout NoteSummaryState, action: NotesAction) {
        switch action {
        case .onAppear:
            load(state: &state)
        case .filter(let category):
            state.filterMode = category
        case .delete(let id):
            do {
                try repository.deleteItem(id: id)
                load(state: &state)
            } catch {
                NSLog("Error while deleting from db: \(error)")
            }
        case .markAsFavoriteUnFavorite(let id, let isFavorite):
            do {
                try repository.setFavorite(id: id, isFavorite: isFavorite)
                load(state: &state)
            } catch {
                NSLog("Error while saving to db: \(error)")
            }
        case .addTapped:
            state.route = .addNote
        case .addCanncelled:
            state.route = nil
        case .addSaved(let item):
            do {
                try repository.addItem(item: item)
                load(state: &state)
            } catch {
                NSLog("Error while saving to db: \(error)")
            }
            state.route = nil
        default:
            break
        }
        
    }
    
    private func load(state: inout NoteSummaryState) {
        do {
            state.items = try repository.fetchAll()
        } catch {
            NSLog("Error while fetching from db: \(error)")
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
