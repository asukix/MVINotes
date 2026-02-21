//
//  NoteView.swift
//  MVINotes
//
//  Created by Seng Phrakonkham on 2026. 02. 04..
//
import SwiftUI

struct NoteView: View {
    @Environment(\.dismiss) private var dismiss
    let id: UUID
    @State var title: String
    @State var summary: String
    @State var details: String
    let onBack: () -> Void
    let onSave: (NoteItemDTO) -> Void

    init (
        id: UUID?,
        title: String?,
        summary: String?,
        details: String?,
        onBack: @escaping () -> Void,
        onSave: @escaping (
            NoteItemDTO
        ) -> Void
    ) {
        self.id = id ?? UUID()
        self.title = title ?? ""
        self.summary = summary ?? ""
        self.details = details ?? ""
        self.onBack = onBack
        self.onSave = onSave
    }

    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .center) {
                TextField("", text: $title, prompt: Text("Title"))
                    .font(.title)
                    .frame(alignment: .leading)
                TextField("", text: $summary, prompt: Text("Summary"))
                    .foregroundStyle(.secondary)
                    .frame(alignment: .leading)
                Divider()
                TextEditor(text: $details)
                    .font(.body)
                    .scrollContentBackground(.hidden)
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    onBack()
                    dismiss()
                } label: {
                    Label("Back", systemImage: "chevron.left")
                }
            }
            ToolbarItemGroup(placement: .automatic) {
                Button(
                    action: {
                        onSave(
                            NoteItemDTO(
                                id: self.id,
                                title: self.title,
                                summary: self.summary,
                                date: Date(),
                                category: .none,
                                details: self.details
                            )
                    )
                }) {
                    Text("Save")
                }
            }
            ToolbarItemGroup(placement: .keyboard) {
                Button {
                    insertBullet()
                } label: {
                    Image(systemName: "list.bullet")
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    // MARK: - Formatting helpers
    private func insertBullet() {
        if !details.isEmpty, details.last != "\n" {
            details.append("\n")
        }
        details.append("\u{2022} ")
    }
}

#Preview {
    NoteView(
        id: UUID(),
        title: "Title",
        summary: "Summary",
        details: "details",
        onBack: {},
        onSave: {_ in })
}

