//
//  AvatarImage.swift
//  DesignSystem
//
//  Copyright © 2026 Adam Young.
//

import SwiftUI

struct AvatarImage: View {

    var role: ChatRole

    var body: some View {
        Image(systemName: role.avatarSymbol)
            .foregroundStyle(role.avatarSymbolColor)
            .padding(5)
            .background(
                Circle().fill(role.bubbleColour.opacity(0.4))
            )
            .symbolRenderingMode(.multicolor)
    }
}

#Preview("User") {
    AvatarImage(role: .user)
}

#Preview("Assistant") {
    AvatarImage(role: .assistant)
}
