//
//  NoteCategory.swift
//  MVINotes
//
//  Created by Seng Phrakonkham on 2026. 02. 09..
//

enum NoteCategory: String, Equatable, CaseIterable {
    case all = "All"
    case none = "None"
    case favorites = "Favorites"
    
    static func category(from category: String?) -> NoteCategory {
        guard let category else {
            return .none
        }
        
        return switch category {
        case "All":
                .all
        case "None":
                .none
        case "Favorites":
                .favorites
        default:
                .none
        }
    }
    
    static func favoriteCategory(isFavoirte: Bool) -> String {
        isFavoirte ? self.favorites.rawValue : self.none.rawValue
    }
}
