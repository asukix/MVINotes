//
//  NotesStore.swift
//  MVINotes
//
//  Created by Seng Phrakonkham on 2026. 02. 11..
//

import Observation
import Foundation

@MainActor
@Observable
final class NotesStore {
    private(set) var state = NoteSummaryState()
    private let controller: NoteListController
    private let reducer: NoteListReducer
    let repository: NotesRepositoryProtocol
    
    init(repository: NotesRepositoryProtocol) {
        self.repository = repository
        self.reducer = NoteListReducer(repository: repository)
        self.controller = NoteListController(repository: repository)
    }
    
    var filterMode: NotesCategory {
        state.filterMode
    }
    
    func send(_ action: NotesAction) {
        controller.process(action) { [weak self] result in
            guard let self else { return }
            self.reducer.reduce(state: &self.state, result: result)
        }
    }
    
}
