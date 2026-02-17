//
//  MessageTextField.swift
//  DesignSystem
//
//  Copyright © 2026 Adam Young.
//

import SwiftUI

public struct MessageTextField: View {

    private enum FocusedField {
        case message
    }

    public var isDisabled: Bool
    public var onSend: (String) -> Void

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
