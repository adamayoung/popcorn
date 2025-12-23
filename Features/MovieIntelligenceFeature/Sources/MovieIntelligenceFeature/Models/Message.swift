//
//  Message.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import SwiftUI

public struct Message: Identifiable, Equatable, Sendable, Hashable {

    public let id: UUID
    let author: Author
    let content: String
    let timestamp: Date

    var localizedText: LocalizedStringKey {
        LocalizedStringKey(content)
    }

    init(
        id: UUID = UUID(),
        author: Author,
        content: String,
        timestamp: Date = .now
    ) {
        self.id = id
        self.author = author
        self.content = content
        self.timestamp = timestamp
    }

}
