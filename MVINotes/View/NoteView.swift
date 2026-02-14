//
//  NoteView.swift
//  MVINotes
//
//  Created by Seng Phrakonkham on 2026. 02. 04..
//
import SwiftUI

struct NoteView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title: String = ""
    @State private var summary: String = ""
    let onCancel: () -> Void
    let onSave: (NoteSummaryDTO) -> Void

    
    @State private var noteText: AttributedString = {
        var a = AttributedString("Add your note…")
        return a
    }()

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
                RichTextEditor(text: $noteText)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    onCancel()
                    dismiss()
                } label: {
                    Label("Back", systemImage: "chevron.left")
                }
            }
            ToolbarItemGroup(placement: .automatic) {
                Button(action: {
                    onSave(NoteSummaryDTO(
                        title: title,
                        summary: summary,
                        date: Date(),
                        category: .none)
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
        var new = noteText
        if !new.characters.isEmpty, new.characters.last != "\n" { new.append(AttributedString("\n")) }
        new.append(AttributedString("\u{2022} "))
        noteText = new
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
    NoteView(onCancel: {}, onSave: {_ in })
}

