//
//  ChatRole.swift
//  DesignSystem
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SwiftUI

public enum ChatRole: Sendable, Hashable {

    case user
    case assistant

}

extension ChatRole {

    var textColor: Color {
        switch self {
        case .user: .white
        case .assistant: .primary
        }
    }

    var bubbleColour: Color {
        switch self {
        case .user: .blue
        case .assistant: .gray.opacity(0.1)
        }
    }

    var avatarSymbol: String {
        switch self {
        case .user: "person.fill"
        case .assistant: "apple.intelligence"
        }
    }

    var avatarSymbolColor: Color {
        switch self {
        case .user: .primary
        case .assistant: .yellow
        }
    }

}
