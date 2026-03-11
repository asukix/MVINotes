//
//  NoteListAction.swift
//  MVINotes
//
//  Created by Seng Phrakonkham on 2026. 02. 05..
//
import Foundation

enum NotesAction {
    case load
    case favoriteAction(id: UUID, isFavorite: Bool)
    case deleteAction(id: UUID)
    case itemAddAction(item: NoteItemDTO)
    case filterAction(category: NotesCategory)
    case navigateToNote(item: NoteItemDTO? = nil)
    case navigateBackToList
    case freezUI
}
