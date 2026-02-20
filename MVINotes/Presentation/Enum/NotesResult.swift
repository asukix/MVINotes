//
//  NotesResult.swift
//  MVINotes
//
//  Created by Seng Phrakonkham on 2026. 02. 11..
//
import Foundation

enum NotesResult {
    enum Add {
        case adding(item: NoteSummaryDTO)
        case addedSuccessfully(item: NoteSummaryDTO)
        case addFailed(item: NoteSummaryDTO, error: Error)
    }

    enum Delete {
        case deleting(id: UUID)
        case deleteSucceeded(id: UUID)
        case deleteFailed(id: UUID, error: Error)
    }

    enum Load {
        case loading
        case loaded(items: [NoteSummaryDTO])
        case loadingFailed(error: Error)
    }

    enum Save {
        case saving(item: NoteSummaryDTO)
        case saved(item: NoteSummaryDTO)
        case savingFailed(item: NoteSummaryDTO, error: Error)
    }

    enum Navigation {
        case navigatingToDetail(id: UUID?)
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
