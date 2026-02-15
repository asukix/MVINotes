//
//  NoteSummaryView.swift
//  MVINotes
//
//  Created by Seng Phrakonkham on 2026. 02. 02..
//

import SwiftUI

struct NoteSummaryView: View{
    let data: NoteSummaryDTO
    let store: NotesStore
    let favoriteTapped: (UUID) -> Void
    
    var favoriteIcone: Image {
        data.category == .favorites ?
        Image(systemName: "star.fill") :
        Image(systemName: "star")
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(data.title)
                    .font(.title2)
                    .bold(true)
                Text(data.summary)
                Text(data.dateString)
            }
            Spacer()
            VStack(spacing: 12) {
                Button(action: {
                    favoriteTapped(data.id)
                }) {
                    favoriteIcone
                        .imageScale(.medium)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.borderless)
                
                Button(action: {
                    store.dispatch(.delete(id: data.id))
                }) {
                    Image(systemName: "trash")
                        .imageScale(.medium)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.borderless)
            }
        }
        .padding(12)
    }
}


#Preview {
//    NoteSummaryView(
//        data: NoteSummaryDTO(
//            title: "MVI practice",
//            summary: "Create a notes app using MVI architecture",
//            date: Date(),
//            category: .none
//        ),
//        store: NotesStore()
//    )
}
