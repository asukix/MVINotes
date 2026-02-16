//
//  NoteListAction.swift
//  MVINotes
//
//  Created by Seng Phrakonkham on 2026. 02. 05..
//
import Foundation

enum NotesAction {
    case onAppear
    case newNote
    case markAsFavoriteUnFavorite(id: UUID, isFavorite: Bool)
    case searchAction(query: String)
    case deleteTapped(id: UUID)
    case deleteSucceeded(id: UUID)
    case deleteFailed(id: UUID, error: Error)
    case filter(category: NoteCategory)
    case addTapped
    case addCanncelled
    case addSaved(item: NoteSummaryDTO)
}
