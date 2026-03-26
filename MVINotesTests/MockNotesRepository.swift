//
//  MockNotesRepository.swift
//  MVINotes
//
//  Created by Phrakonkham Sengpraseuth on 2026. 03. 17..
//
import Foundation
@testable import MVINotes

final class MockNotesRepository: NotesRepositoryProtocol {
    var fetchAllCalled = false
    var addItemCalled = false
    var updateItemCalled = false
    var setFavoriteCalled = false
    
    // Helper properties for easier testing
    var shouldThrowError = false
    var existingItems: [NoteItemDTO] = []
    
    enum MockError: Error {
        case testError
    }
    
    func fetchAll() async throws -> [NoteItemDTO] {
        fetchAllCalled = true
        if shouldThrowError { throw MockError.testError }
        return existingItems
    }
    
    func addItem(item: NoteItemDTO) async throws {
        addItemCalled = true
        
        if shouldThrowError {
            throw MockError.testError
        }
    }
    
    func updateItem(item: NoteItemDTO) async throws {
        updateItemCalled = true
        
        if shouldThrowError {
            throw MockError.testError
        }
    }
    
    func deleteItem(id: UUID) async throws {
        if shouldThrowError {
            throw MockError.testError
        }
    }
    
    func setFavorite(id: UUID, isFavorite: Bool) async throws {
        setFavoriteCalled = true
        
        if shouldThrowError {
            throw MockError.testError
        }
    }
}
