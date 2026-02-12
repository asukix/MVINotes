//
//  NoteView.swift
//  MVINotes
//
//  Created by Seng Phrakonkham on 2026. 02. 04..
//
import SwiftUI

struct NoteView: View {
    let title: String = "MVI Practice"
    let date: String = "2026.02.04."

    
    @State private var noteText: AttributedString = {
        var a = AttributedString("Add your note…")
        return a
    }()

    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .center, spacing: 8) {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(date)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                }

                RichTextEditor(text: $noteText)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
            .padding()
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Button {
                    insertBullet()
                } label: {
                    Image(systemName: "list.bullet")
                }
            }
        }
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
    NoteView()
}
