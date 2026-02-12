//
//  NoteListReducer.swift
//  MVINotes
//
//  Created by Seng Phrakonkham on 2026. 02. 11..
//

struct NoteListReducer {
    func reduce(state: inout NoteSummaryState, action: NoteListAction) {
        switch action {
        case .filter(let category):
            state.filterMode = category
        case .delete(let id):
            state.items.removeAll { $0.id == id }
        default:
            break
        }
        
    }
}
