//
//  NotesRepositoryIntegrationTests.swift
//  MVINotes
//
//  Created by Phrakonkham Sengpraseuth on 2026. 03. 08..
//

import XCTest
@testable import MVINotes
import CoreData

final class NotesRepositoryIntegrationTests: XCTestCase {
    private var sut: NotesRepositoryProtocol!
    private var context: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        context = TestCoreDataStack.makeContext()
        sut = NotesRepository(context: context)
    }
    
    override func tearDown() {
        sut = nil
        context = nil
        super.tearDown()
    }
    
    lazy var noteStub: NoteItemDTO = {
        let date = Date()
        return NoteItemDTO(
            title: "Test Note",
            summary: "Summary",
            date: date,
            category: .favorites,
            details: "Details"
        )
    }()
    
    @MainActor
    func testAddAndFetchSavedItemIsReturnedCorrectly() async throws {
        let note = noteStub
        
        try await sut.addItem(item: note)
        let fetched = try await sut.fetchAll()
        
        XCTAssertEqual(fetched.count, 1)
        XCTAssertEqual(fetched.first?.title, "Test Note")
        XCTAssertEqual(fetched.first?.summary, "Summary")
        XCTAssertEqual(fetched.first?.date, note.date)
        XCTAssertEqual(fetched.first?.category, NotesCategory.favoriteCategory(isFavoirte: true))
        XCTAssertEqual(fetched.first?.details, "Details")
    }
    
    func testDeleteFetchNoItemIsReturned() async throws {
        let note = noteStub
        
        try await sut.addItem(item: note)
        try await sut.deleteItem(id: note.id)
        let fetched = try await sut.fetchAll()
        
        XCTAssertTrue(fetched.isEmpty)
    }
    
    @MainActor
    func testUpdateFetchItemIsUpdated() async throws {
        let note = noteStub
        let date2 = Calendar.current.date(byAdding: .day, value: 1, to: note.date)!
        let category2 = NotesCategory.none
        
        let updatedNote = NoteItemDTO(
            id: note.id,
            title: "Updated Test Note",
            summary: "Updated Summary",
            date: date2,
            category: category2,
            details: "Updated Details"
        )
        
        try await sut.addItem(item: note)
        try await sut.updateItem(item: updatedNote)
        let fetched = try await sut.fetchAll()
        
        XCTAssertEqual(fetched.first?.title, "Updated Test Note")
        XCTAssertEqual(fetched.first?.summary, "Updated Summary")
        XCTAssertEqual(fetched.first?.date, date2)
        XCTAssertEqual(fetched.first?.category, category2)
        XCTAssertEqual(fetched.first?.details, "Updated Details")
        
    }
    
    func testSetFavoriteFalseThenFetchItemCategoryIsFavorite() async throws {
        let note = noteStub
        
        try await sut.addItem(item: note)
        try await sut.setFavorite(id: note.id, isFavorite: false)
        let fetched = try await sut.fetchAll()
        
        XCTAssertEqual(fetched.first?.category, NotesCategory.favoriteCategory(isFavoirte: false))
    }
    
    func testSetFavoriteTrueThenFetchItemCategoryIsFavorite() async throws {
        let date = Date()
        let note = NoteItemDTO(
            title: "Test Note",
            summary: "Summary",
            date: date,
            category: NotesCategory.none,
            details: "Details"
        )
        
        try await sut.addItem(item: note)
        try await sut.setFavorite(id: note.id, isFavorite: true)
        let fetched = try await sut.fetchAll()
        
        XCTAssertEqual(fetched.first?.category, NotesCategory.favoriteCategory(isFavoirte: true))
    }
}
