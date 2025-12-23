//
//  MessageTextField.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import SwiftUI

struct MessageTextField: View {

    private enum FocusedField {
        case message
    }

    var isDisabled: Bool
    var onSend: (String) -> Void

    @State private var text: String = ""
    @FocusState private var focusedField: FocusedField?

    var body: some View {
        HStack(alignment: .bottom) {
            TextField(
                "Message...",
                text: $text,
                axis: .vertical
            )
            .textFieldStyle(.plain)
            .padding(.vertical, 11)
            .padding(.leading, 13)
            .padding(.trailing, 50)
            .glassEffect(
                in: RoundedRectangle(
                    cornerRadius: 22,
                    style: .continuous
                )
            )
            .overlay(alignment: .bottomTrailing) {
                Button(action: sendMessage) {
                    Image(systemName: "paperplane")
                        .fontWeight(.medium)
                        .padding(5)
                }
                .buttonStyle(.plain)
                .disabled(isDisabled || text.isEmpty)
                .padding(.bottom, 6)
                .padding(.trailing, 10)
            }
            .onSubmit(sendMessage)
            .focused($focusedField, equals: .message)
        }
        .focusEffectDisabled()
        .onAppear {
            focusedField = .message
        }
    }

    private func sendMessage() {
        guard !isDisabled else {
            return
        }

        guard !text.isEmpty else {
            return
        }

        onSend(text)
        text = ""
        focusedField = .message
    }

}

#Preview {
    NavigationStack {
        List {}
            .safeAreaInset(edge: .bottom) {
                MessageTextField(isDisabled: false, onSend: { _ in })
                    .padding()
                    .background(.clear)
            }
    }
}
