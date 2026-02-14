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
                NotesFilterBar(
                    selected: store.filterMode,
                    onSelect: {
                        store.dispatch(.filter(category: $0))
                    }
                )
                List(store.state.filteredItems) { item in
                    VStack {
                        NoteSummaryView(
                            data: item,
                            store: store,
                            favoriteTapped: { store.dispatch(.markAsFavoriteUnFavorite(id: $0)) }
                        )
                    }
                    .padding(.vertical, 8)
                }
                .toolbar {
                    Button("+New") {
                        store.dispatch(.addTapped)
                    }
                }
                Spacer()
            }
            .navigationTitle("Notes")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(item: Binding(
                get: { store.state.route },
                set: { _ in }
            )) { route in
                switch route {
                case .addNote:
                    NoteView(
                        onCancel: { store.dispatch(.addCanncelled) },
                        onSave: { store.dispatch(.addSaved(item: $0)) }
                    )
                }
            }
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

//    
//    private var header: some View {
//        HStack {
////            NavigationLink(destination: NoteView()) {
////                Text("+ New Note")
////            }
//            Spacer()
//            Text("Notes")
//            Spacer()
//            Button(action: {
//            }) {
//                Image(systemName: "magnifyingglass")
//            }
//        }
//        .padding(.horizontal)
//    }
