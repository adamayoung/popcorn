//
//  GameMetadata.swift
//  GamesCatalogFeature
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import SwiftUI

public struct GameMetadata: Identifiable, Equatable, Sendable {

    public let id: Int
    public let name: String
    public let description: String
    public let iconSystemName: String
    public let color: Color

    public init(
        id: Int,
        name: String,
        description: String,
        iconSystemName: String,
        color: Color
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.iconSystemName = iconSystemName
        self.color = color
    }

}

extension GameMetadata {

    // swiftlint:disable line_length
    static var mocks: [GameMetadata] {
        [
            GameMetadata(
                id: 1,
                name: "Plot Remix",
                description:
                "Get the movie overview - but rewritten in a completely wild, unexpected style. Decode the twisted summary and guess the film before your brain melts.",
                iconSystemName: "movieclapper",
                color: .blue
            ),
            GameMetadata(
                id: 2,
                name: "Poster Pixelation",
                description:
                "A famous movie poster starts off as a blurry mess. Reveal it piece by piece and call the title before your eyes finally catch up.”",
                iconSystemName: "photo.stack",
                color: .green
            )
        ]
    }
    // swiftlint:enable line_length

}
