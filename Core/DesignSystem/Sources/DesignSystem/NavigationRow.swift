//
//  NavigationRow.swift
//  DesignSystem
//
//  Copyright © 2026 Adam Young.
//

import SwiftUI

public struct NavigationRow<Content: View>: View {

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let action: () -> Void
    @ViewBuilder
    private let content: Content

    @State private var isPressed = false

    public init(
        action: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.action = action
        self.content = content()
    }

    public var body: some View {
        Button(action: action) {
            HStack {
                content
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
                    .imageScale(.small)
                    .accessibilityHidden(true)
            }
            .padding(.vertical, .spacing8)
            .contentShape(Rectangle())
            .background(
                isPressed
                    ? Color.secondary.opacity(0.15)
                    : Color.clear
            )
        }
        .buttonStyle(.plain)
        .onLongPressGesture(
            minimumDuration: 0.01,
            pressing: { pressing in
                if reduceMotion {
                    isPressed = pressing
                } else {
                    withAnimation(.easeOut(duration: 0.15)) {
                        isPressed = pressing
                    }
                }
            },
            perform: {}
        )
    }
}

#Preview {
    NavigationRow {} content: {
        Text("Row")
    }
}
