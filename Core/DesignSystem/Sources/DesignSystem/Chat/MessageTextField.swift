//
//  MessageTextField.swift
//  DesignSystem
//
//  Copyright © 2025 Adam Young.
//

import SwiftUI

///
/// A text field for composing and sending chat messages.
///
/// Provides a styled text input with a send button. The field supports
/// multiline text and includes a glass effect background. The send button
/// is disabled when the field is empty or when input is disabled.
///
public struct MessageTextField: View {

    private enum FocusedField {
        case message
    }

    /// Whether the text field and send button are disabled.
    public var isDisabled: Bool

    /// A closure called when the user sends a message.
    public var onSend: (String) -> Void

    /// Creates a new message text field.
    ///
    /// - Parameters:
    ///   - isDisabled: Whether input is disabled.
    ///   - onSend: A closure called with the message text when sent.
    public init(isDisabled: Bool, onSend: @escaping (String) -> Void) {
        self.isDisabled = isDisabled
        self.onSend = onSend
    }

    @State private var text: String = ""
    @FocusState private var focusedField: FocusedField?

    public var body: some View {
        HStack(alignment: .bottom) {
            ZStack(alignment: .bottomTrailing) {
                TextField(LocalizedStringResource("MESSAGE", bundle: .module), text: $text, axis: .vertical)
                    .textFieldStyle(.plain)
                    .onSubmit(sendMessage)
                    .focused($focusedField, equals: .message)
                    .padding(.vertical, 11)
                    .padding(.leading, 13)
                    .padding(.trailing, 50)
                    .glassEffect(
                        in: RoundedRectangle(
                            cornerRadius: 22,
                            style: .continuous
                        )
                    )

                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                        .frame(width: 32, height: 32)
                        .background(Color.accentColor, in: Circle())
                }
                .buttonStyle(.plain)
                .contentShape(Circle())
                .disabled(isDisabled || text.isEmpty)
                .opacity(isDisabled || text.isEmpty ? 0.5 : 1.0)
                .padding(.bottom, 6)
                .padding(.trailing, 6)
            }
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
