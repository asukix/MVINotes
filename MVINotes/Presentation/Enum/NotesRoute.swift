//
//  NotesRoute.swift
//  MVINotes
//
//  Created by Seng Phrakonkham on 2026. 02. 13..
//

enum NotesRoute: Equatable, Identifiable, Hashable {
    case noteDetails(item: NoteItemDTO?)
    
    var id: String {
        switch self {
        case .noteDetails: return "noteDetails"
        }
    }
}
