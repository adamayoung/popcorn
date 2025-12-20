//
//  GameMetadataMapper.swift
//  GamesCatalogFeature
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import GamesCatalogDomain
import SwiftUI

struct GameMetadataMapper {

    func map(_ gameMetadata: GamesCatalogDomain.GameMetadata) -> GameMetadata {
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
