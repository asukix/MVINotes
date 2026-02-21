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
                        store.send(.filterAction(category: $0))
                    }
                )
                List(store.state.filteredItems) { item in
                    VStack {
                        NoteSummaryView(
                            data: item,
                            store: store,
                            favoriteTapped: {
                                store
                                    .send(.favoriteAction(
                                            id: $0,
                                            isFavorite: item.category != NotesCategory.favorites)
                                    )
                            }
                        )
                    }
                    .padding(.vertical, 8)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        store.send(.navigateToNote(item: item))
                    }
                }
                .toolbar {
                    Button("+New") {
                        store.send(.navigateToNote())
                    }
                }
                Spacer()
            }
            .onAppear() {
                store.send(.load)
            }
            .navigationTitle("Notes")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(item: Binding<NotesRoute?>(
                get: { store.state.route },
                set: { _ in }
            )) { route in
                switch route {
                case .noteDetails(let item):
                    NoteView(
                        id: item?.id,
                        title: item?.title,
                        summary: item?.summary,
                        details: item?.details,
                        onBack: { store.send(.navigateBackToList) },
                        onSave: { store.send(.itemAddAction(item: $0)) }
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
