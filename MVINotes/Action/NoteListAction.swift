//
//  NoteListAction.swift
//  MVINotes
//
//  Created by Seng Phrakonkham on 2026. 02. 05..
//
import Foundation

enum NoteListAction {
    case newNote
    case markAsFavoriteAction
    case searchAction(query: String)
    case edit
    case delete(id: UUID)
    case filter(category: NoteCategory)
    case add(item: NoteSummaryDTO)
}
