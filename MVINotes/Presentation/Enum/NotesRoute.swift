//
//  NotesRoute.swift
//  MVINotes
//
//  Created by Seng Phrakonkham on 2026. 02. 13..
//

enum NotesRoute: Equatable, Identifiable {
    case addNote
    
    var id: String {
        switch self {
        case .addNote: return "addNote"
        }
    }
}
