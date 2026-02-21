//
//  NoteSummaryModel.swift
//  MVINotes
//
//  Created by Seng Phrakonkham on 2026. 02. 08..
//
import Foundation

struct NoteItemDTO: Identifiable, Hashable, Equatable {
    let id: UUID
    var title: String
    var summary: String
    var date: Date
    var category: NotesCategory
    var details: String
    
    init(
        id: UUID = UUID(),
        title: String,
        summary: String,
        date: Date,
        category: NotesCategory,
        details: String = ""
    ) {
        self.id = id
        self.title = title
        self.summary = summary
        self.date = date
        self.category = category
        self.details = details
    }
    
    static func == (lhs: NoteItemDTO, rhs: NoteItemDTO) -> Bool {
        return lhs.title == rhs.title &&
        lhs.summary == rhs.summary &&
        lhs.date == rhs.date &&
        lhs.category == rhs.category &&
        lhs.details == rhs.details
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(summary)
        hasher.combine(date)
        hasher.combine(category)
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MMM.dd"
        return formatter.string(from: self.date)        
    }
}

