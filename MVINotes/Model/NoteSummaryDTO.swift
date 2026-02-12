//
//  NoteSummaryModel.swift
//  MVINotes
//
//  Created by Seng Phrakonkham on 2026. 02. 08..
//
import Foundation

struct NoteSummaryDTO: Identifiable {
    let id: UUID = UUID()
    var title: String
    var summary: String
    var date: Date
    var category: NoteCategory
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MMM.dd"
        return formatter.string(from: self.date)        
    }
}
