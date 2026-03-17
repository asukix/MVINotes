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
    
    // MARK: - Navigation Tests
    
    @Test("Navigate to note emits navigating to detail")
    func navigateToNoteEmitsNavigatingToDetail() async throws {
        // Given
        let note = noteStub
        var emittedResults: [NotesResult] = []
        
        // When
        sut.process(.navigateToNote(item: note)) { result in
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
        
        #expect(item?.id == note.id)
        #expect(item?.title == note.title)
    }
    
    /**
     case .filterAction(let category):
         emit(.filter(.selected(category: category)))
     **/
    
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
    
    // MARK: - Add/Update Tests
    
    @Test("Item add action emits saving state first")
    func itemAddActionEmitsSavingState() async throws {
        // Given
        let note = noteStub
        var emittedResults: [NotesResult] = []
        
        // When
        sut.process(.itemAddAction(item: note)) { result in
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
        
        #expect(item.id == note.id)
    }
    
    @Test("Item add action for new item emits added successfully")
    func itemAddActionForNewItemEmitsSuccess() async throws {
        // Given
        let note = noteStub
        var emittedResults: [NotesResult] = []
        mockRepository.shouldReturnEmptyList = true // Simulate item doesn't exist
        
        // When
        sut.process(.itemAddAction(item: note)) { result in
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
        
        #expect(item.id == note.id)
        #expect(mockRepository.addItemCalled == true)
    }
    
    @Test("Item add action for existing item emits updated successfully")
    func itemAddActionForExistingItemEmitsSuccess() async throws {
        // Given
        let note = noteStub
        var emittedResults: [NotesResult] = []
        mockRepository.existingItems = [note] // Simulate item exists
        
        // When
        sut.process(.itemAddAction(item: note)) { result in
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
        
        #expect(item.id == note.id)
        #expect(mockRepository.updateItemCalled == true)
    }
    
    @Test("Item add action with failure emits add failed")
    func itemAddActionWithFailureEmitsError() async throws {
        // Given
        let note = noteStub
        var emittedResults: [NotesResult] = []
        mockRepository.shouldThrowError = true // Simulate error
        
        // When
        sut.process(.itemAddAction(item: note)) { result in
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
        
        guard case .addFailed(let item, let error) = finalState else {
            Issue.record("Expected addFailed state")
            return
        }
        
        #expect(item.id == note.id)
        #expect(error != nil)
    }
}
