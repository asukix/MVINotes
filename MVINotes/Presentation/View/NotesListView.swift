//
//  NotesListView.swift
//  MVINotes
//
//  Created by Seng Phrakonkham on 2026. 02. 04..
//

import SwiftUI

struct NotesListView: View {
    @State var store: NotesStore
    
    var body: some View {
        NavigationStack {
            VStack {
                NotesFilterBar(
                    selected: store.filterMode,
                    onSelect: {
                        store.send(.filter(category: $0))
                    }
                )
                List(store.state.filteredItems) { item in
                    VStack {
                        NoteSummaryView(
                            data: item,
                            store: store,
                            favoriteTapped: {
                                store
                                    .send(
                                        .markAsFavoriteUnFavorite(
                                            id: $0,
                                            isFavorite: item.category != NoteCategory.favorites
                                        )
                                    )
                            }
                        )
                    }
                    .padding(.vertical, 8)
                }
                .toolbar {
                    Button("+New") {
                        store.send(.addTapped)
                    }
                }
                Spacer()
            }
            .onAppear() {
                store.send(.onAppear)
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
                        onCancel: { store.send(.addCanncelled) },
                        onSave: { store.send(.addSaved(item: $0)) }
                    )
                }
            }
        }
    }
}

#Preview {
//    NotesListView(store: NotesStore())
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
