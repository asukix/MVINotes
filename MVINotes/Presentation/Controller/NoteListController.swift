//
//  NoteListController.swift
//  MVINotes
//
//  Created by Seng Phrakonkham on 2026. 02. 11..
//

@MainActor
final class NoteListController {
    func process(
        _ action: NotesAction,
        emit: @escaping(NoteResult) -> Void
    ) {
        emit(.applied(action))
    }
}
