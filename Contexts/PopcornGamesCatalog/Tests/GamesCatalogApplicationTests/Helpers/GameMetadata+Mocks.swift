//
//  GameMetadata+Mocks.swift
//  PopcornGamesCatalog
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import GamesCatalogDomain

extension GameMetadata {

    static func mock(
        id: Int = 1,
        name: String = "Test Game",
        description: String = "A test game description",
        iconSystemName: String = "gamecontroller",
        color: GameColorTag = .blue
    ) -> GameMetadata {
        GameMetadata(
            id: id,
            name: name,
            description: description,
            iconSystemName: iconSystemName,
            color: color
        )
    }

    static var mocks: [GameMetadata] {
        [
            .mock(id: 1, name: "Plot Remix", iconSystemName: "movieclapper", color: .blue),
            .mock(id: 2, name: "Poster Pixelation", iconSystemName: "photo.stack", color: .green),
            .mock(id: 3, name: "Emoji Plot Decoder", iconSystemName: "face.smiling", color: .red)
        ]
    }

}
