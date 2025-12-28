//
//  ChatMessageContent.swift
//  DesignSystem
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// The content of a chat message.
///
/// Represents the different types of content that can appear in a chat message.
/// Currently supports text content, with potential for future expansion to
/// support images, audio, or other media types.
///
public enum ChatMessageContent: Sendable, Hashable {

    /// Text content with the associated string value.
    case text(String)

}
