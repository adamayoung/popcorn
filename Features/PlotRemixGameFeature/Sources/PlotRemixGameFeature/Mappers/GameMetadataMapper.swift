//
//  GameMetadataMapper.swift
//  PlotRemixGameFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import GamesCatalogDomain
import SwiftUI

/// Maps a context ``GamesCatalogDomain/GameMetadata`` to the feature's ``GameMetadata`` presentation model.
public struct GameMetadataMapper {

    /// Creates a game-metadata mapper.
    public init() {}

    /// Maps a context ``GamesCatalogDomain/GameMetadata`` to a presentation ``GameMetadata``.
    public func map(_ metadata: GamesCatalogDomain.GameMetadata) -> GameMetadata {
        GameMetadata(
            id: metadata.id,
            name: metadata.name,
            description: metadata.description,
            iconSystemName: metadata.iconSystemName,
            color: map(metadata.color)
        )
    }

}

extension GameMetadataMapper {

    private func map(_ color: GameColorTag) -> Color {
        switch color {
        case .blue: .blue
        case .green: .green
        case .red: .red
        case .yellow: .yellow
        }
    }

}
