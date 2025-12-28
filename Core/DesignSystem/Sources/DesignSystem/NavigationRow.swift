//
//  NavigationRow.swift
//  DesignSystem
//
//  Copyright © 2025 Adam Young.
//

import SwiftUI

///
/// A row component with navigation chevron and press feedback.
///
/// Use this component to create tappable rows that indicate navigation
/// to another screen. The row displays custom content with a chevron
/// indicator on the trailing edge and provides visual feedback when pressed.
///
public struct NavigationRow<Content: View>: View {

    private let action: () -> Void
    @ViewBuilder private let content: Content

    @State private var isPressed = false

    /// Creates a new navigation row.
    ///
    /// - Parameters:
    ///   - action: The action to perform when the row is tapped.
    ///   - content: A view builder that creates the row content.
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
                    .foregroundColor(.secondary)
                    .imageScale(.small)
            }
            .padding(.vertical, 8)
            .contentShape(Rectangle())
            .background(
                isPressed
                    ? Color(.systemFill)
                    : Color.clear
            )
        }
        .buttonStyle(.plain)
        .onLongPressGesture(
            minimumDuration: 0.01,
            pressing: { pressing in
                withAnimation(.easeOut(duration: 0.15)) {
                    isPressed = pressing
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
