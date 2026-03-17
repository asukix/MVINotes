//
//  NoteListReducer.swift
//  MVINotes
//
//  Created by Seng Phrakonkham on 2026. 02. 11..
//
import Foundation

struct NoteListReducer {
    
    func reduce(
        state: inout NoteSummaryState,
        result: NotesResult
    ) {
        switch result {
        case .navigation(let nav):
            reduceNavigation(state: &state, navigation: nav)

        case .addOrUpdate(let addOrUpdate):
            reduceSave(state: &state, addOrUpdate: addOrUpdate)
            
        case .delete(let delete):
            reduceDelete(state: &state, delete: delete)
            
        case .load(let load):
            reduceLoad(state: &state, load: load)
            
        case .filter(let filter):
            switch filter {
            case .selected(let category):
                state.filterMode = category
            }
        
        case .favorite(let favorite):
            reduceFavorite(
                state: &state,
                favorite: favorite,
            )
        case .freezUI:
            // For instruments learning: Time Profle + Hang
            do { sleep(2) }
            
        case .save:
            break
        }
    }
    
    private func reduceSave(
        state: inout NoteSummaryState,
        addOrUpdate: NotesResult.AddOrUpdate
    ) {
        switch addOrUpdate {
        case .saving(let item):
            NSLog("Adding item")
            
        case .addedSuccessfully(let item):
            state.items.append(item)
            state.route = nil
            
        case .addFailed(let item, let error):
            if let idx = state.items.firstIndex(of: item) {
                state.items.remove(at: idx)
                state.route = nil
            }
            NSLog("Error while adding item: \(error)")
        }
    }
    
    private func reduceNavigation(
        state: inout NoteSummaryState,
        navigation: NotesResult.Navigation
    ) {
        switch navigation {
        case .navigatingToDetail(let item):
            state.route = .noteDetails(item: item)
            
        case .navigateToBackToList:
            state.route = nil
        }
    }
    
    private func reduceDelete(
        state: inout NoteSummaryState,
        delete: NotesResult.Delete
    ) {
        switch delete {
        case .deleting(let id):
            guard let item = state.items.first(where: { $0.id == id }),
                  let idx = state.items.firstIndex(of: item)
            else { return }
            state.deletingItems.insert(item)
            state.items.remove(at: idx)
            
        case .deleteFailed(let id, let error):
            if let deletingItem = state.deletingItems.first(where: { $0.id == id }) {
                state.items.append(deletingItem)
                state.deletingItems.remove(deletingItem)
                NSLog("Error while deleting item: \(error)")
            }
            
        case .deleteSucceeded(let id):
            if let deletingItem = state.deletingItems.first(where: { $0.id == id }) {
                state.deletingItems.remove(deletingItem)
            }
        }
    }
    
    private func reduceLoad(
        state: inout NoteSummaryState,
        load: NotesResult.Load
    ) {
        switch load {
        case .loading:
            NSLog("Loading notes...")
            
        case .loaded(let items):
            state.items = items
            
        case .loadingFailed:
            NSLog("Error while loading notes")
        }
    }
    
    private func reduceFavorite(
        state: inout NoteSummaryState,
        favorite: NotesResult.Favorite,
    ) {
        switch favorite {
        case .settingFavorite(let id, let category):
            guard let idx = state.items.firstIndex(where: { $0.id == id }) else {
                return
            }
            state.favoritingItemId = id
            state.items[idx].category = category
            
        case .setFavoriteSuccessfully(let id, let isFavorite):
            state.favoritingItemId = nil
            
        case .setFavoriteFailed(let id, let category, let error):
            NSLog("Error while setting favorite: \(error)")
            guard let idx = state.items.firstIndex(where: { $0.id == id }) else {
                return
            }
            state.items[idx].category = category
            state.favoritingItemId = nil
        }
    }
}

