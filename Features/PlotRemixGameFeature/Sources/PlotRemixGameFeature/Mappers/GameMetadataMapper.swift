//
//  GameMetadataMapper.swift
//  PlotRemixGameFeature
//
//  Created by Adam Young on 11/12/2025.
//

import Foundation
import GamesCatalogDomain
import SwiftUI

struct GameMetadataMapper {

    func map(_ metadata: GamesCatalogDomain.GameMetadata) -> GameMetadata {
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
