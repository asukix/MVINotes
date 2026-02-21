//
//  NotesResult.swift
//  MVINotes
//
//  Created by Seng Phrakonkham on 2026. 02. 11..
//
import Foundation

enum NotesResult {
    enum Add {
        case adding(item: NoteItemDTO)
        case addedSuccessfully(item: NoteItemDTO)
        case addFailed(item: NoteItemDTO, error: Error)
    }

    enum Delete {
        case deleting(id: UUID)
        case deleteSucceeded(id: UUID)
        case deleteFailed(id: UUID, error: Error)
    }

    enum Load {
        case loading
        case loaded(items: [NoteItemDTO])
        case loadingFailed(error: Error)
    }

    enum Save {
        case saving(item: NoteItemDTO)
        case saved(item: NoteItemDTO)
        case savingFailed(item: NoteItemDTO, error: Error)
    }

    enum Navigation {
        case navigatingToDetail(item: NoteItemDTO?)
        case navigateToBackToList
        case routeChanged(NotesRoute?)
    }

    enum Filter {
        case selected(category: NotesCategory)
    }
    
    enum Favorite {
        case settingFavorite(id: UUID, category: NotesCategory)
        case setFavoriteSuccessfully(id: UUID, category: NotesCategory)
        case setFavoriteFailed(id: UUID, category: NotesCategory, error: Error)
    }

    case add(Add)
    case delete(Delete)
    case load(Load)
    case save(Save)
    case navigation(Navigation)
    case filter(Filter)
    case favorite(Favorite)
}
