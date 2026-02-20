//
//  NotesCategory.swift
//  MVINotes
//
//  Created by Seng Phrakonkham on 2026. 02. 09..
//

enum NotesCategory: String, Equatable, CaseIterable {
    case all = "All"
    case none = "None"
    case favorites = "Favorites"
    
    static func category(from category: String?) -> NotesCategory {
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
    
    static func favoriteCategory(isFavoirte: Bool) -> NotesCategory {
        isFavoirte ? self.favorites : self.none
    }
    
    static func favoriteCategoryAsString(isFavoirte: Bool) -> String {
        favoriteCategory(isFavoirte: isFavoirte).rawValue
    }
}
