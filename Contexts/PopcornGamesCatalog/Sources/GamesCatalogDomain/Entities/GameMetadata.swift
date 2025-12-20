//
//  GameMetadata.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public struct GameMetadata: Identifiable, Sendable {

    public let id: Int
    public let name: String
    public let description: String
    public let iconSystemName: String
    public let color: GameColorTag

    public init(
        id: Int,
        name: String,
        description: String,
        iconSystemName: String,
        color: GameColorTag
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.iconSystemName = iconSystemName
        self.color = color
    }

}
