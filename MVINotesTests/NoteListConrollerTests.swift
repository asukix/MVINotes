//
//  NoteListControllerTests.swift
//  MVINotes
//
//  Created by Seng Phrakonkham on 2026. 03. 17..
//

import Testing
import Foundation
@testable import MVINotes

@Suite("Note List Controller Tests")
@MainActor
struct NoteListControllerTests {
    let sut: NoteListController
    let mockRepository: MockNotesRepository
    
    init() {
        mockRepository = MockNotesRepository()
        sut = NoteListController(repository: mockRepository)
    }
    
    let noteStub = NoteItemDTO(
        title: "Test Note",
        summary: "Test Summary",
        date: Date(),
        category: .none,
        details: "Test Details"
    )
    
    // MARK: - Filter Tests
    @Test("Filter action emits correct filter for category", arguments: NotesCategory.allCases)
    func filterActionEmitsFilter(category: NotesCategory) async throws {
        // Given
        var emittedResults: [NotesResult] = []
        
        // When
        sut.process(.filterAction(category: category)) { result in
            emittedResults.append(result)
        }
        
        // Then
        #expect(emittedResults.count == 1)
        
        guard case .filter(let filter) = emittedResults.first else {
            Issue.record("Expected filter result")
            return
        }
        
        guard case .selected(let emittedCategory) = filter else {
            Issue.record("Expected selected filter")
            return
        }
        
        #expect(emittedCategory == category)
    }
}

// MARK: navigation tests
extension NoteListControllerTests {
    
    @Test("Navigate to note emits navigating to detail")
    func navigateToNoteEmitsNavigatingToDetail() async throws {
        // Given
        var emittedResults: [NotesResult] = []
        
        // When
        sut.process(.navigateToNote(item: noteStub)) { result in
            emittedResults.append(result)
        }
        
        // Then
        #expect(emittedResults.count == 1)
        
        guard case .navigation(let navigation) = emittedResults.first else {
            Issue.record("Expected navigation result")
            return
        }
        
        guard case .navigatingToDetail(let item) = navigation else {
            Issue.record("Expected navigatingToDetail")
            return
        }
        
        #expect(item?.id == noteStub.id)
        #expect(item?.title == noteStub.title)
    }
    
    @Test("Navigate back to list emits navigate to back to list")
    func navigateBackToListEmitsNavigateToBackToList() {
        // Given
        var emittedResults: [NotesResult] = []
        
        // When
        sut.process(.navigateBackToList) { result in
            emittedResults.append(result)
        }
        
        // Then
        #expect(emittedResults.count == 1)
        
        guard case .navigation(let navigation) = emittedResults.first else {
            Issue.record("Expected navigation result")
            return
        }
        
        guard case .navigateToBackToList = navigation else {
            Issue.record("Expected navigateToBackToList")
            return
        }
    }
}

// MARK: load tests
extension NoteListControllerTests {
    @Test("Load action emits loading state first")
    func loadActionEmitsLoadingStateFirst() async throws {
        // Given
        var emittedResults: [NotesResult] = []
        
        // When
        sut.process(NotesAction.load) { result in
            emittedResults.append(result)
        }
        
        // Then
        #expect(emittedResults.count == 1)
        
        guard case .load(let load) = emittedResults.first else {
            Issue.record("Expected load result")
            return
        }
        
        guard case .loading = load else {
            Issue.record("Expected loading state")
            return
        }
    }
    
    @Test("Load action emits loaded state")
    func testLoadEmitsLoadedState() async throws {
        // Given
        var emittedResults: [NotesResult] = []
        mockRepository.existingItems = [noteStub]
        
        // When
        sut.process(NotesAction.load) { result in
            emittedResults.append(result)
        }
        
        // Wait for async operation
        try await Task.sleep(for: .milliseconds(100))
        
        // Then
        #expect(emittedResults.count == 2)
        
        guard case .load(let load) = emittedResults.last else {
            Issue.record("Expected load state")
            return
        }
        
        guard case .loaded(let items) = load else {
            Issue.record("Expected loaded state")
            return
        }
        
        #expect(items == [noteStub])
    }
    
    @Test("Load action emits loading failed state on error")
    func testLoadEmitsLoadingFailedStateOnError() async throws {
        // Given
        var emittedResults: [NotesResult] = []
        mockRepository.shouldThrowError = true
        
        // When
        sut.process(NotesAction.load) { result in
            emittedResults.append(result)
        }
        
        // Wait for async operation
        try await Task.sleep(for: .milliseconds(100))
        
        // Then
        guard case .load(let load) = emittedResults.last else {
            Issue.record("Expected load state")
            return
        }
        
        guard case .loadingFailed(let error) = load else {
            Issue.record("Expected loaded state")
            return
        }
    }
    
}

// MARK: item delete tests
extension NoteListControllerTests {
    
    @Test("Item delete action emits deleting state first")
    func itemDeleteActionEmitsDeletingState() async throws {
        // Given
        var emittedResults: [NotesResult] = []
        
        // When
        sut.process(.deleteAction(id: noteStub.id)) { result in
            emittedResults.append(result)
        }
        
        // Then
        #expect(emittedResults.count == 1)
        
        guard case .delete(let delete) = emittedResults.first else {
            Issue.record("Expected delete result")
            return
        }
        
        guard case .deleting(let id) = delete else {
            Issue.record("Expected deleting state with provided id")
            return
        }
        
        #expect(id == noteStub.id)
    }
    
    @Test("Item delete action emits delete succeded")
    func itemDeleteActionEmitsDeleteSucceded() async throws {
        // Given
        var emittedResults: [NotesResult] = []
        mockRepository.existingItems = [noteStub]
        
        // When
        sut.process(.deleteAction(id: noteStub.id)) { result in
            emittedResults.append(result)
        }
        
        // Wait for async operation
        try await Task.sleep(for: .milliseconds(100))
        
        // Then
        #expect(emittedResults.count == 2)
        
        guard case .delete(let delete) = emittedResults.last else {
            Issue.record("Expected delete result")
            return
        }
        
        guard case .deleteSucceeded(let id) = delete else {
            Issue.record("Expected deleteSuccess result")
            return
        }
        
        #expect(id == noteStub.id)
        #expect(mockRepository.deleteItemCalled == true)
    }
    
    @Test("Item delete action emits delete failed")
    func itemDeleteActionEmitsDeleteFailed() async throws {
        // Given
        var emittedResults: [NotesResult] = []
        mockRepository.shouldThrowError = true
        
        // When
        sut.process(.deleteAction(id: noteStub.id)) { result in
            emittedResults.append(result)
        }
        
        // Wait for async operation
        try await Task.sleep(for: .milliseconds(100))
        
        // Then
        #expect(emittedResults.count == 2)
        
        guard case .delete(let delete) = emittedResults.last else {
            Issue.record("Expected delete result")
            return
        }
        
        guard case .deleteFailed(let id, _) = delete else {
            Issue.record("Expected deleteFailed result")
            return
        }
        
        #expect(id == noteStub.id)
    }
}

// MARK: item add tests
extension NoteListControllerTests {
    
    @Test("Item add action emits saving state first")
    func itemAddActionEmitsSavingState() async throws {
        // Given
        var emittedResults: [NotesResult] = []
        
        // When
        sut.process(.itemAddAction(item: noteStub)) { result in
            emittedResults.append(result)
        }
        
        // Then - Should emit saving first
        #expect(emittedResults.count >= 1)
        
        guard case .addOrUpdate(let addOrUpdate) = emittedResults.first else {
            Issue.record("Expected addOrUpdate result")
            return
        }
        
        guard case .saving(let item) = addOrUpdate else {
            Issue.record("Expected saving state")
            return
        }
        
        #expect(item.id == noteStub.id)
    }
    
    @Test("Item add action for new item emits added successfully")
    func itemAddActionForNewItemEmitsSuccess() async throws {
        // Given
        var emittedResults: [NotesResult] = []
        // When
        sut.process(.itemAddAction(item: noteStub)) { result in
            emittedResults.append(result)
        }
        
        // Wait for async operation
        try await Task.sleep(for: .milliseconds(100))
        
        #expect(emittedResults.count == 2)
        
        guard case .addOrUpdate(let finalState) = emittedResults.last else {
            Issue.record("Expected addOrUpdate result")
            return
        }
        
        guard case .addedSuccessfully(let item) = finalState else {
            Issue.record("Expected addedSuccessfully state")
            return
        }
        
        #expect(item.id == noteStub.id)
        #expect(mockRepository.addItemCalled == true)
    }
    
    @Test("Item add action for existing item emits updated successfully")
    func itemAddActionForExistingItemEmitsSuccess() async throws {
        // Given
        var emittedResults: [NotesResult] = []
        mockRepository.existingItems = [noteStub] // Simulate item exists
        
        // When
        sut.process(.itemAddAction(item: noteStub)) { result in
            emittedResults.append(result)
        }
        
        // Wait for async operation
        try await Task.sleep(for: .milliseconds(100))
        
        // Then - Should emit saving and then success
        #expect(emittedResults.count == 2)
        
        guard case .addOrUpdate(let finalState) = emittedResults.last else {
            Issue.record("Expected addOrUpdate result")
            return
        }
        
        guard case .addedSuccessfully(let item) = finalState else {
            Issue.record("Expected addedSuccessfully state")
            return
        }
        
        #expect(item.id == noteStub.id)
        #expect(mockRepository.updateItemCalled == true)
    }
    
    @Test("Item add action with failure emits add failed")
    func itemAddActionWithFailureEmitsError() async throws {
        // Given
        var emittedResults: [NotesResult] = []
        mockRepository.shouldThrowError = true // Simulate error
        
        // When
        sut.process(.itemAddAction(item: noteStub)) { result in
            emittedResults.append(result)
        }
        
        // Wait for async operation
        try await Task.sleep(for: .milliseconds(100))
        
        // Then - Should emit saving and then failure
        #expect(emittedResults.count == 2)
        
        guard case .addOrUpdate(let finalState) = emittedResults.last else {
            Issue.record("Expected addOrUpdate result")
            return
        }
        
        guard case .addFailed(let item, _) = finalState else {
            Issue.record("Expected addFailed state")
            return
        }
        
        #expect(item.id == noteStub.id)
    }
}

// MARK: item favorite tests
extension NoteListControllerTests {
    @Test("Set favorite action emits setting favorite first", arguments: [true, false])
    func setFavoriteActionEmitsSettingFavoriteFirst(isFavorite: Bool) async throws {
        // Given
        var emittedResults: [NotesResult] = []
        
        // When
        sut.process(.favoriteAction(id: noteStub.id, isFavorite: isFavorite)){ result in
            emittedResults.append(result)
        }
        
        // Then
        #expect(emittedResults.count == 1)
        
        guard case .favorite(let favorite) = emittedResults.last else {
            Issue.record("Expected favorite action result")
            return
        }
        
        guard case .settingFavorite(let id, let category) = favorite else {
            Issue.record("Expected setting favorite result")
            return
        }
        
        #expect(id == noteStub.id)
        #expect(category == NotesCategory.favoriteCategory(isFavoirte: isFavorite))
    }
    
    @Test("Set favorite action emits set favorite successfully", arguments: [true, false])
    func setFavoriteActionEmitsSetFavoriteSuccessfully(isFavorite: Bool) async throws {
        // Given
        var emittedResults: [NotesResult] = []
        let expectedCategory = NotesCategory.favoriteCategory(isFavoirte: isFavorite)
        
        // When
        sut.process(.favoriteAction(id: noteStub.id, isFavorite: isFavorite)){ result in
            emittedResults.append(result)
        }
        
        // Wait for async operation
        try await Task.sleep(for: .milliseconds(100))
        
        // Then
        #expect(emittedResults.count == 2)
        
        guard case .favorite(let favorite) = emittedResults.last else {
            Issue.record("Expected favorite action result")
            return
        }
        
        guard case .setFavoriteSuccessfully(id: let id, category: let category) = favorite else {
            Issue.record("Expected set favorite successfully result")
            return
        }
        
        #expect(id == noteStub.id)
        #expect(category == expectedCategory)
    }
    
    @Test("Set favorite action emits setFavoriteFailed", arguments: [true, false])
    func setFavoriteActionEmitsSetFavoriteFailed(isFavorite: Bool) async throws {
        // Given
        var emittedResults: [NotesResult] = []
        mockRepository.shouldThrowError = true
        let expectedCategory = NotesCategory.favoriteCategory(isFavoirte: !isFavorite)
        
        // When
        sut.process(.favoriteAction(id: noteStub.id, isFavorite: isFavorite)){ result in
            emittedResults.append(result)
        }
        
        // Wait for async operation
        try await Task.sleep(for: .milliseconds(100))
        
        // Then
        #expect(emittedResults.count == 2)
        
        guard case .favorite(let favorite) = emittedResults.last else {
            Issue.record("Expected favorite action result")
            return
        }
        
        guard case .setFavoriteFailed(id: let id, category: let category, error: _) = favorite else {
            Issue.record("Expected set favorite failed result")
            return
        }
        
        #expect(id == noteStub.id)
        #expect(category == expectedCategory)
    }
}
