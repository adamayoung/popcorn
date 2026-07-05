//
//  GameMetadataMapper.swift
//  GamesCatalogFeature
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
    public func map(_ gameMetadata: GamesCatalogDomain.GameMetadata) -> GameMetadata {
        GameMetadata(
            id: gameMetadata.id,
            name: gameMetadata.name,
            description: gameMetadata.description,
            iconSystemName: gameMetadata.iconSystemName,
            color: map(gameMetadata.color)
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
