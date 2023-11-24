//
//  FileInspector.swift
//  Replin
//
//  Created by Julian on 21/11/23.
//

import Foundation
import SwiftUI

struct FileInspector: View {
    @State private var editingText: String = ""
    private var file: FileItem
    @State private var keyValues = [KeyValueItem]()
    @State private var temporaryText: String = ""
    @FocusState private var isFocused: Bool

    init(file: FileItem) {
        self.file = file
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(file.url.relativeString).font(.caption).multilineTextAlignment(.leading).padding().textSelection(.enabled)
            
            Table(keyValues) {
                TableColumn("key") {
                    Text($0.key).textSelection(.enabled)
                }
                TableColumn("value") {
                    EditableText(text: $0.value)
                }
            }

            TextEditor(text: $editingText)
                .font(.body)
                .disabled(true)
                .onChange(of: file) {
                    self.editingText = FileUtils.getTextContent(fileURL: file.url)
                    self.keyValues.removeAll()
                    self.keyValues = FileUtils.extractJSONKeysAndValues(editingText)
                    
                    print("KV:", self.keyValues.count)
                    print(self.keyValues[0])
                }
        }
    }
}
