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
    case itemAddAction(item: NoteSummaryDTO)
    case filterAction(category: NotesCategory)
    case navigateToNote(id: UUID?)
    case navigateBackToList
    case noteSaveAction(item: NoteSummaryDTO)
}
