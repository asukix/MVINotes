//
//  NotesFilterBar.swift
//  MVINotes
//
//  Created by Seng Phrakonkham on 2026. 02. 12..
//
import SwiftUI

struct NotesFilterBar: View {
    let selected: NotesCategory
    let onSelect: (NotesCategory) -> Void
    
    var body: some View {
        Picker(
            "Filter",
            selection:
                Binding(
                    get: { selected },
                    set: { onSelect($0) }
                )
        ) {
            ForEach(NotesCategory.allCases, id: \.self) { category in
                Text(category.rawValue)
                    .tag(category)
            }
        }
        .pickerStyle(.segmented)
    }
}

#Preview {
    NotesFilterBar(
        selected: .all,
        onSelect: { _ in }
    )
}
