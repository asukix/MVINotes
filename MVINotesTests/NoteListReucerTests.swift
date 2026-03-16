//
//  NoteListReucerTests.swift
//  MVINotes
//
//  Created by Phrakonkham Sengpraseuth on 2026. 03. 12..
//

@testable import MVINotes
import XCTest

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

// MARK: Add or update reduce tests
extension NoteListReucerTests {
    @MainActor
    func test_add_saveIemToItems() {
        let note = noteStub
        
        var state = NoteSummaryState()
        
        sut.reduce(
            state: &state,
            result: .addOrUpdate(.addedSuccessfully(item: note))
        )
        
        XCTAssertEqual(state.items.count, 1)
        XCTAssertEqual(state.items.first, note)
    }
    
    @MainActor
    func test_add_failedNotAddToItems() {
        let note = noteStub
        let note2 = NoteItemDTO(
            title: "Test2",
            summary: "Test summary2",
            date: Date(),
            category: .none,
            details: "Test details2"
        )
        
        var state = NoteSummaryState(items: [note, note2])
        
        sut.reduce(
            state: &state,
            result: .addOrUpdate(.addFailed(
                item: note2,
                error: NSError(domain: "", code: 0, userInfo: nil))
            )
        )
        
        XCTAssertEqual(state.items.count, 1)
        XCTAssertEqual(state.items.first, note)
    }
}

// MARK: FAvorite reduce tests
extension NoteListReucerTests {
    @MainActor
    func test_setFavorite_updatesItemCategory() {
        let note = noteStub
        
        var state = NoteSummaryState(items: [note])
        
        sut.reduce(
            state: &state,
            result: .favorite(.settingFavorite(id: note.id, category: .favorites))
        )
        
        XCTAssertEqual(state.favoritingItemId, note.id)
        XCTAssertEqual(state.items.first?.category, NotesCategory.favorites)
    }
    
    @MainActor
    func test_setFavorite_whenItemIsNotInState_doesNothing() {
        let note = noteStub
        
        var state = NoteSummaryState(items: [])
        
        sut.reduce(
            state: &state,
            result: .favorite(.settingFavorite(id: note.id, category: .favorites))
        )
        
        XCTAssertNil(state.favoritingItemId)
    }
    
    @MainActor
    func test_setFavorite_whenSettingFavoriteFails_preservesItemCategory() {
        let note = noteStub
        
        var state = NoteSummaryState(items: [note])
        
        sut.reduce(
            state: &state,
            result: .favorite(.setFavoriteFailed(id: note.id, category: NotesCategory.none, error: NSError(domain: "", code: 0, userInfo: nil)))
        )
        
        XCTAssertEqual(state.favoritingItemId, nil)
        XCTAssertEqual(state.items.first?.category, NotesCategory.none)
    }
    
    @MainActor
    func test_setFavorite_whenSettingFavoriteFails_andNoItems_doesNothing() {
        var state = NoteSummaryState(items: [])
        
        sut.reduce(
            state: &state,
            result: .favorite(.setFavoriteFailed(id: UUID(), category: NotesCategory.none, error: NSError(domain: "", code: 0, userInfo: nil)))
        )
        
        XCTAssertNil(state.favoritingItemId)
    }
    
    @MainActor
    func test_setFavorite_whenSettingFavoriteFails_andNoSpecificFavoriteIdInState_doesNothing() {
        let note = noteStub
        let note2 = noteStub2
        var state = NoteSummaryState(
            items: [note],
            favoritingItemId: note.id
        )
        
        sut.reduce(
            state: &state,
            result: .favorite(.setFavoriteFailed(id: note2.id, category: NotesCategory.none, error: NSError(domain: "", code: 0, userInfo: nil)))
        )
        
        XCTAssertEqual(state.favoritingItemId, note.id)
    }
}

// MARK: Delete reduce tests
extension NoteListReucerTests {
    @MainActor
    func test_delete_removesItemFromItems_andAddsToDeletingItems() {
        
        let note = noteStub
        
        var state = NoteSummaryState(items: [note])
        
        sut.reduce(
            state: &state,
            result: .delete(.deleting(id: note.id))
        )
        
        XCTAssertTrue(state.items.isEmpty)
        XCTAssertTrue(state.deletingItems.contains(note))
    }
    
    @MainActor
    func test_delete_deleteFailed_addsItemBackToItems() {
        
        let note = noteStub
        
        var state = NoteSummaryState(
            items: [],
            deletingItems: [note]
        )
        let error = NSError(domain: "Test", code: 0, userInfo: nil)
        
        sut.reduce(
            state: &state,
            result: .delete(.deleteFailed(id: note.id, error: error))
        )
        
        XCTAssertTrue(state.items.contains(note))
        XCTAssertEqual(state.deletingItems.count, 0)
    }
    
    @MainActor
    func test_delete_deleteSucceeded_removesFromDeletingItems() {
        let note = noteStub
        
        var state = NoteSummaryState(deletingItems: [note])
        
        sut.reduce(
            state: &state,
            result: .delete(.deleteSucceeded(id: note.id))
        )
        
        XCTAssertEqual(state.deletingItems, [])
    }
}
