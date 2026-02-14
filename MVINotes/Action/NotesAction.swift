//
//  NoteListAction.swift
//  MVINotes
//
//  Created by Seng Phrakonkham on 2026. 02. 05..
//
import Foundation

enum NotesAction {
    case newNote
    case markAsFavoriteUnFavorite(id: UUID)
    case searchAction(query: String)
    case delete(id: UUID)
    case filter(category: NoteCategory)
    case addTapped
    case addCanncelled
    case addSaved(item: NoteSummaryDTO)
}
