//
//  EditableText.swift
//  Replin
//
//  Created by Julian on 23/11/23.
//

import Foundation
import SwiftUI

struct EditableText: View {
    @State private var text: String
    @State private var temporaryText: String
    @FocusState private var isFocused: Bool
    
    init(text: String) {
        self.temporaryText = text
        self.text = text
    }

    var body: some View {
        HStack {
            TextField("", text: $temporaryText)
                .focused($isFocused, equals: true)
                .onTapGesture { isFocused = true }
                .onExitCommand { temporaryText = text; isFocused = false }

            if (text != temporaryText) {
                Spacer()
                Button {
                    print("Apply changes", temporaryText)
                    
                    text = temporaryText
                } label: {
                    Text("Apply change")
                }.buttonStyle(.borderedProminent)
            }
        }
    }
}
