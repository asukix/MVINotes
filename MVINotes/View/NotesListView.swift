//
//  NotesListView.swift
//  MVINotes
//
//  Created by Seng Phrakonkham on 2026. 02. 04..
//

import SwiftUI

struct NotesListView: View {
    @State private var store = NotesStore()
    
    var body: some View {
        NavigationStack {
            VStack {
                header
                NotesFilterBar(
                    selected: store.filterMode,
                    onSelect: {
                        store.dispatch(.filter(category: $0))
                    }
                )
                items(
                    items: store.state.filteredItems,
                    store: store
                )
                Spacer()
            }
            .navigationTitle("Notes")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var header: some View {
        HStack {
            NavigationLink(destination: NoteView()) {
                Text("+ New Note")
            }
            Spacer()
            Text("Notes")
            Spacer()
            Button(action: {
            }) {
                Image(systemName: "magnifyingglass")
            }
        }
        .padding(.horizontal)
    }
    
    private func items(
        items: [NoteSummaryDTO],
        store: NotesStore,
    ) -> some View {
        return List(items) { item in
            VStack {
                NoteSummaryView(
                    data: item,
                    store: store
                )
            }
            .padding(.vertical, 8)
        }
    }
}

struct NoteItem: Identifiable {
    let id: UUID = UUID()
    let title: String
    let summary: String
}

#Preview {
    NotesListView()
}
