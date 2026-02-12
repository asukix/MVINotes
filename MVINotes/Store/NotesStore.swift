//
//  NotesStore.swift
//  MVINotes
//
//  Created by Seng Phrakonkham on 2026. 02. 11..
//

import Observation
@MainActor
@Observable
final class NotesStore {
    private(set) var state = NoteSummaryState()
    private let controller = NoteListController()
    private let reducer = NoteListReducer()
    
    var filterMode: NoteCategory {
        state.filterMode
    }
    
    func dispatch(_ action: NoteListAction) {
        controller.process(action) { [weak self] result in
            guard let self else { return }
            self.reducer.reduce(state: &self.state, action: action)
        }
    }
    
}
