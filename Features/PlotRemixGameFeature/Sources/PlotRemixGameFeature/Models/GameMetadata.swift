//
//  GameMetadata.swift
//  PlotRemixGameFeature
//
//  Created by Adam Young on 11/12/2025.
//

import SwiftUI

public struct GameMetadata: Identifiable, Sendable {

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

    static var mock: GameMetadata {
        GameMetadata(
            id: 1,
            name: "Plot Remix",
            description:
                "Get the movie overview - but rewritten in a completely wild, unexpected style. Decode the twisted summary and guess the film before your brain melts.",
            iconSystemName: "movieclapper",
            color: .blue
        )
    }

}
