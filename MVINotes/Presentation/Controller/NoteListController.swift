//
//  NoteListController.swift
//  MVINotes
//
//  Created by Seng Phrakonkham on 2026. 02. 11..
//
import Foundation

@MainActor
final class NoteListController {
    let repository: NotesRepositoryProtocol
    
    init(repository: NotesRepositoryProtocol) {
        self.repository = repository
    }
    
    func process(
        _ action: NotesAction,
        emit: @escaping(NotesResult) -> Void
    ) {
        switch action {
        case .load:
            load(emit: emit)
            
        case .filterAction(let category):
            emit(.filter(.selected(category: category)))
            
        case .navigateToNote(let item):
            emit(.navigation(.navigatingToDetail(item: item)))
            
        case .navigateBackToList:
            emit(.navigation(.navigateToBackToList))
            
        case .itemAddAction(let item):
            itemAddAction(item: item, emit: emit)
            
        case .deleteAction(let id):
            deleteTapped(id: id, emit: emit)
            
        case .favoriteAction(let id, let isFavorite):
            favoriteTapped(id: id, isFavorite: isFavorite, emit: emit)
            
        }
    }
    
    private func load(
        emit: @escaping(
            NotesResult
        ) -> Void
    ) {
        emit(.load(.loading))
        Task {
            do {
                let items = try repository.fetchAll()
                await MainActor.run {
                    emit(.load(.loaded(items: items)))
                }
            } catch {
                emit(.load(.loadingFailed(error: error)))
            }
        }
    }
    
    private func itemAddAction(
        item: NoteItemDTO,
        emit: @escaping(
            NotesResult
        ) -> Void
    ) {
        emit(.add(.adding(item: item)))
        
        Task {
            do {
                try self.repository.addItem(item: item)
                await MainActor.run {
                    emit(.add(.addedSuccessfully(item: item)))
                }
            } catch {
                await MainActor.run {
                    emit(.add(.addFailed(item: item, error: error)))
                }
            }
        }
    }
    
    private func deleteTapped(
        id: UUID,
        emit: @escaping(
            NotesResult
        ) -> Void
    ) {
        emit(.delete(.deleting(id: id)))

        Task {
            do {
                try self.repository.deleteItem(id: id)
                await MainActor.run {
                    emit(.delete(.deleteSucceeded(id: id)))
                }
            } catch {
                await MainActor.run {
                    emit(.delete(.deleteFailed(id: id, error: error)))
                }
            }
        }
    }
    
    private func favoriteTapped(
        id: UUID,
        isFavorite: Bool,
        emit: @escaping (
            NotesResult
        ) -> Void
    ){
        let category =  NotesCategory.favoriteCategory(isFavoirte: isFavorite)
        emit(.favorite(.settingFavorite(id: id, category: category)))
        Task {
            do {
                try self.repository.setFavorite(id: id, isFavorite: isFavorite)
                await MainActor.run {
                    emit(.favorite(.setFavoriteSuccessfully(id: id, category: category)))
                }
            } catch {
                await MainActor.run {
                    let category =  NotesCategory.favoriteCategory(isFavoirte: !isFavorite)
                    emit(.favorite(.setFavoriteFailed(id: id, category: category, error: error)))
                }
            }
        }
    }
}

