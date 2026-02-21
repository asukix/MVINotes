//
//  NoteView.swift
//  MVINotes
//
//  Created by Seng Phrakonkham on 2026. 02. 04..
//
import SwiftUI

struct NoteView: View {
    @Environment(\.dismiss) private var dismiss
    @State var title: String
    @State var summary: String
    @State var details: AttributedString
    let onBack: () -> Void
    let onSave: (NoteItemDTO) -> Void

    init (
        title: String?,
        summary: String?,
        details: String?,
        onBack: @escaping () -> Void,
        onSave: @escaping (
            NoteItemDTO
        ) -> Void
    ) {
        self.title = title ?? ""
        self.summary = summary ?? ""
        self.details = AttributedString(details ?? "")
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
                RichTextEditor(text: $details)
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
                Button(action: {
                    onSave(NoteItemDTO(
                        title: title,
                        summary: summary,
                        date: Date(),
                        category: .none,
                        details: details.description
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
        var new = details
        if !new.characters.isEmpty, new.characters.last != "\n" { new.append(AttributedString("\n")) }
        new.append(AttributedString("\u{2022} "))
        details = new
    }
}

private struct RichTextEditor: View {
    @Binding var text: AttributedString
    @State private var backingText: String = ""

    var body: some View {
        TextEditor(text: $backingText)
            .font(.body)
            .scrollContentBackground(.hidden)
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .onAppear { backingText = String(text.characters) }
            .onChange(of: text) { _, newValue in
                let plain = String(newValue.characters)
                if backingText != plain { backingText = plain }
            }
            .onChange(of: backingText) { _, newValue in
                var updated = text
                updated = AttributedString(newValue)
                text = updated
            }
    }
}

#Preview {
    NoteView(
        title: "Title",
        summary: "Summary",
        details: "details",
        onBack: {},
        onSave: {_ in })
}

