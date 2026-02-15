//
//  NoteSummaryModel.swift
//  MVINotes
//
//  Created by Seng Phrakonkham on 2026. 02. 08..
//
import Foundation

struct NoteSummaryDTO: Identifiable {
    let id: UUID
    var title: String
    var summary: String
    var date: Date
    var category: NoteCategory
    
    init(
        id: UUID = UUID(),
        title: String,
        summary: String,
        date: Date,
        category: NoteCategory
    ) {
        self.id = id
        self.title = title
        self.summary = summary
        self.date = date
        self.category = category
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MMM.dd"
        return formatter.string(from: self.date)        
    }
}
