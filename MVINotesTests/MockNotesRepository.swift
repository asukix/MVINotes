//
//  MockNotesRepository.swift
//  MVINotes
//
//  Created by Phrakonkham Sengpraseuth on 2026. 03. 17..
//
import Foundation
@testable import MVINotes

final class MockNotesRepository: NotesRepositoryProtocol {
    var fetchAllResult: Result<[NoteItemDTO], Error> = .success([])
    var addItemResult: Result<Void, Error> = .success(())
    var updateItemResult: Result<Void, Error> = .success(())
    var deleteItemResult: Result<Void, Error> = .success(())
    var setFavoriteResult: Result<Void, Error> = .success(())
    
    var fetchAllCalled = false
    var addItemCalled = false
    var updateItemCalled = false
    var deleteItemCalled = false
    var setFavoriteCalled = false
    
    // Helper properties for easier testing
    var shouldReturnEmptyList = false
    var shouldThrowError = false
    var existingItems: [NoteItemDTO] = []
    
    enum MockError: Error {
        case testError
    }
    
    func fetchAll() async throws -> [NoteItemDTO] {
        fetchAllCalled = true
        
        if shouldThrowError {
            throw MockError.testError
        }
        
        if shouldReturnEmptyList {
            return []
        }
        
        if !existingItems.isEmpty {
            return existingItems
        }
        
        return try fetchAllResult.get()
    }
    
    func addItem(item: NoteItemDTO) async throws {
        addItemCalled = true
        
        if shouldThrowError {
            throw MockError.testError
        }
        
        try addItemResult.get()
    }
    
    func updateItem(item: NoteItemDTO) async throws {
        updateItemCalled = true
        
        if shouldThrowError {
            throw MockError.testError
        }
        
        try updateItemResult.get()
    }
    
    func deleteItem(id: UUID) async throws {
        deleteItemCalled = true
        
        if shouldThrowError {
            throw MockError.testError
        }
        
        try deleteItemResult.get()
    }
    
    func setFavorite(id: UUID, isFavorite: Bool) async throws {
        setFavoriteCalled = true
        
        if shouldThrowError {
            throw MockError.testError
        }
        
        try setFavoriteResult.get()
    }
}
