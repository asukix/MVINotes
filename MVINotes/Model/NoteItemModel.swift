//
//  NoteItemModel.swift
//  MVINotes
//
//  Created by Seng Phrakonkham on 2026. 02. 08..
//
import Foundation

struct NoteItemModel {
    let id = UUID()
    let title: String
    let date: Date
    let note: AttributedString
}
