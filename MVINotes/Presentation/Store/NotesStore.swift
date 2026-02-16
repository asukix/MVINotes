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
    private let reducer: NoteListReducer
    let repository: NotesRepositoryProtocol
    
    init(repository: NotesRepositoryProtocol) {
        self.repository = repository
        self.reducer = NoteListReducer(repository: repository)
    }
    
    var filterMode: NoteCategory {
        state.filterMode
    }
    
    func send(_ action: NotesAction) {
        controller.process(action) { [weak self] result in
            guard let self else { return }
            
            switch action {
            case .deleteTapped(let id):
                Task {
                    do {
                        try self.repository.deleteItem(id: id)
                        await MainActor.run {
                            self.reducer.reduce(state: &self.state, action: .deleteSucceeded(id: id))
                        }
                    } catch {
                        await MainActor.run {
                            self.reducer.reduce(state: &self.state, action: .deleteFailed(id: id, error: error))
                        }
                    }
                }
            default:
                break
            }
        }
        self.reducer.reduce(state: &self.state, action: action)
    }
    
}
