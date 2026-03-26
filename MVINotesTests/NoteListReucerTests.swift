//
//  NoteListReucerTests.swift
//  MVINotes
//
//  Created by Phrakonkham Sengpraseuth on 2026. 03. 12..
//

@testable import MVINotes
import XCTest
import Testing

class NoteListReucerTests: XCTestCase {
    private var sut: NoteListReducer!
    
    override func setUp() {
        super.setUp()
        sut = .init()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    lazy var noteStub: NoteItemDTO = {
        NoteItemDTO(
            title: "Test",
            summary: "Test summary",
            date: Date(),
            category: .none,
            details: "Test details"
        )
    }()
    
    lazy var noteStub2: NoteItemDTO = {
        NoteItemDTO(
            title: "Different note",
            summary: "Different summary",
            date: Date(),
            category: .none,
            details: "Test details2"
        )
    }()
    
}

struct NoteListReducerSwiftTests {
    @Test("Note List Reducer test when filtering notes", arguments: NotesCategory.allCases)
    func testFilterSetFilterMode(category: NotesCategory) {
        // Given
        var sut: NoteListReducer = .init()
        var state = NoteSummaryState()
        
        // When - filtering by none category
        sut.reduce(
            state: &state,
            result: .filter(.selected(category: category))
        )
        
        // Then
        #expect(state.filterMode == category)
    }
}

// MARK: Add or update reduce tests
extension NoteListReucerTests {
    @MainActor
    func testAddSaveItemToItems() {
        // Given
        let note = noteStub
        var state = NoteSummaryState()
        
        // When
        sut.reduce(
            state: &state,
            result: .addOrUpdate(.addedSuccessfully(item: note))
        )
        
        // Then
        XCTAssertEqual(state.items.count, 1)
        XCTAssertEqual(state.items.first, note)
    }
    
    @MainActor
    func testAddFailedNotAddToItems() {
        // Given
        let note = noteStub
        let note2 = NoteItemDTO(
            title: "Test2",
            summary: "Test summary2",
            date: Date(),
            category: .none,
            details: "Test details2"
        )
        var state = NoteSummaryState(items: [note, note2])
        
        // When
        sut.reduce(
            state: &state,
            result: .addOrUpdate(.addFailed(
                item: note2,
                error: NSError(domain: "", code: 0, userInfo: nil))
            )
        )
        
        // Then
        XCTAssertEqual(state.items.count, 1)
        XCTAssertEqual(state.items.first, note)
    }
}

// MARK: FAvorite reduce tests
extension NoteListReucerTests {
    @MainActor
    func testSetFavoriteUpdatesItemCategory() {
        // Given
        let note = noteStub
        var state = NoteSummaryState(items: [note])
        
        // When
        sut.reduce(
            state: &state,
            result: .favorite(.settingFavorite(id: note.id, category: .favorites))
        )
        
        // Then
        XCTAssertEqual(state.favoritingItemId, note.id)
        XCTAssertEqual(state.items.first?.category, NotesCategory.favorites)
    }
    
    @MainActor
    func testSetFavoriteWhenItemIsNotInStateDoesNothing() {
        // Given
        let note = noteStub
        var state = NoteSummaryState(items: [])
        
        // When
        sut.reduce(
            state: &state,
            result: .favorite(.settingFavorite(id: note.id, category: .favorites))
        )
        
        // Then
        XCTAssertNil(state.favoritingItemId)
    }
    
    @MainActor
    func testSetFavoriteWhenSettingFavoriteFailsPreservesItemCategory() {
        // Given
        let note = noteStub
        var state = NoteSummaryState(items: [note])
        
        // When
        sut.reduce(
            state: &state,
            result: .favorite(.setFavoriteFailed(id: note.id, category: NotesCategory.none, error: NSError(domain: "", code: 0, userInfo: nil)))
        )
        
        // Then
        XCTAssertEqual(state.favoritingItemId, nil)
        XCTAssertEqual(state.items.first?.category, NotesCategory.none)
    }
    
    @MainActor
    func testSetFavoriteWhenSettingFavoriteFailsAndNoItemsDoesNothing() {
        // Given
        var state = NoteSummaryState(items: [])
        
        // When
        sut.reduce(
            state: &state,
            result: .favorite(.setFavoriteFailed(id: UUID(), category: NotesCategory.none, error: NSError(domain: "", code: 0, userInfo: nil)))
        )
        
        // Then
        XCTAssertNil(state.favoritingItemId)
    }
    
    @MainActor
    func testSetFavoriteWhenSettingFavoriteFailsAndNoSpecificFavoriteIdInStateDoesNothing() {
        // Given
        let note = noteStub
        let note2 = noteStub2
        var state = NoteSummaryState(
            items: [note],
            favoritingItemId: note.id
        )
        
        // When
        sut.reduce(
            state: &state,
            result: .favorite(.setFavoriteFailed(id: note2.id, category: NotesCategory.none, error: NSError(domain: "", code: 0, userInfo: nil)))
        )
        
        // Then
        XCTAssertEqual(state.favoritingItemId, note.id)
    }
}

// MARK: Delete reduce tests
extension NoteListReucerTests {
    @MainActor
    func testDeleteRemovesItemFromItemsAndAddsToDeletingItems() {
        // Given
        let note = noteStub
        var state = NoteSummaryState(items: [note])
        
        // When
        sut.reduce(
            state: &state,
            result: .delete(.deleting(id: note.id))
        )
        
        // Then
        XCTAssertTrue(state.items.isEmpty)
        XCTAssertTrue(state.deletingItems.contains(note))
    }
    
    @MainActor
    func testDeleteDeleteFailedAddsItemBackToItems() {
        // Given
        let note = noteStub
        var state = NoteSummaryState(
            items: [],
            deletingItems: [note]
        )
        let error = NSError(domain: "Test", code: 0, userInfo: nil)
        
        // When
        sut.reduce(
            state: &state,
            result: .delete(.deleteFailed(id: note.id, error: error))
        )
        
        // Then
        XCTAssertTrue(state.items.contains(note))
        XCTAssertEqual(state.deletingItems.count, 0)
    }
    
    @MainActor
    func testDeleteDeleteSucceededRemovesFromDeletingItems() {
        // Given
        let note = noteStub
        var state = NoteSummaryState(deletingItems: [note])
        
        // When
        sut.reduce(
            state: &state,
            result: .delete(.deleteSucceeded(id: note.id))
        )
        
        // Then
        XCTAssertEqual(state.deletingItems, [])
    }
}

// MARK: navigation reduce tests
extension NoteListReucerTests {
    func testNavigationNavigatingToDetailSetsRouteToNoteDetails() {
        // Given
        let note = noteStub
        var state = NoteSummaryState()
        
        // When
        sut.reduce(
            state: &state,
            result: .navigation(.navigatingToDetail(item: note))
        )
        
        // Then
        XCTAssertEqual(state.route, .noteDetails(item: note))
    }
    
    @MainActor
    func testNavigationNavigateBackToListSetsRouteToNil() {
        // Given
        let note = noteStub
        var state = NoteSummaryState(route: .noteDetails(item: note))
        
        // When
        sut.reduce(
            state: &state,
            result: .navigation(.navigateToBackToList)
        )
        
        // Then
        XCTAssertNil(state.route)
    }
}
