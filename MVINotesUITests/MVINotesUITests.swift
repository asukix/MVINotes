//
//  MVINotesUITests.swift
//  MVINotesUITests
//
//  Created by Seng Phrakonkham on 2026. 02. 02..
//

import XCTest
@testable import MVINotesShared

final class MVINotesUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    @MainActor
    func testCreateNewNote() throws {
        // GIVEN - Az alkalmazás elindul és látjuk a Notes listát
        let app = XCUIApplication()
        app.launch()
        
        let addNewButton = app.buttons[AccessibilityIds.NoteListViewIds.newNoteButton.rawValue]
        XCTAssertTrue(addNewButton.waitForExistence(timeout: 4))
        
        addNewButton.tap()
        
        let titleTextField = app.textFields[AccessibilityIds.NoteViewIds.titleTextField.rawValue]
        XCTAssertTrue(titleTextField.waitForExistence(timeout: 3))
        titleTextField.tap()
        titleTextField.typeText("UI Test Note")
        
        let saveButton = app.buttons[AccessibilityIds.NoteViewIds.saveButton.rawValue]
        XCTAssertTrue(saveButton.waitForExistence(timeout: 1))
        saveButton.tap()
        
        let noteCell = app.staticTexts["UI Test Note"]
        XCTAssertTrue(noteCell.waitForExistence(timeout: 3))
        
    }
    
}
