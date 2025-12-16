//
//  DefaultGameRepository.swift
//  PopcornGamesCatalog
//
//  Created by Adam Young on 09/12/2025.
//

import Foundation
import GamesCatalogDomain

final class DefaultGameRepository: GameRepository {

    private let featureFlagProvider: any FeatureFlagProviding

    init(featureFlagProvider: some FeatureFlagProviding) {
        self.featureFlagProvider = featureFlagProvider
    }

    func games() async throws(GameRepositoryError) -> [GameMetadata] {
        Self.availableGames.values
            .filter { game in
                if game.id == 1 && !isPlotRemixEnabled {
                    return false
                }

                if game.id == 2 && !isPosterPixelationGameEnabled {
                    return false
                }

                if game.id == 3 && !isEmojiPlotDecoderEnabled {
                    return false
                }

                if game.id == 4 && !isTimelineTangleGameEnabled {
                    return false
                }

                return true
            }
            .sorted {
                $0.name.localizedCompare($1.name) == .orderedAscending
            }
    }

    func game(id: Int) async throws(GameRepositoryError) -> GameMetadata {
        guard let game = Self.availableGames[id] else {
            throw .notFound
        }

        return game
    }

}

extension DefaultGameRepository {

    private var isPlotRemixEnabled: Bool {
        (try? featureFlagProvider.isPlotRemixGameEnabled()) == true
    }

    private var isEmojiPlotDecoderEnabled: Bool {
        (try? featureFlagProvider.isEmojiPlotDecoderEnabled()) == true
    }

    private var isPosterPixelationGameEnabled: Bool {
        (try? featureFlagProvider.isPosterPixelationGameEnabled()) == true
    }

    private var isTimelineTangleGameEnabled: Bool {
        (try? featureFlagProvider.isTimelineTangleGameEnabled()) == true
    }

}

extension DefaultGameRepository {

    private static let availableGames: [GameMetadata.ID: GameMetadata] = [
        1: GameMetadata(
            id: 1,
            name: "Plot Remix",
            description:
                "Get the movie overview - but rewritten in a completely wild, unexpected style. Decode the twisted summary and guess the film before your brain melts.",
            iconSystemName: "movieclapper",
            color: .blue
        ),
        2: GameMetadata(
            id: 2,
            name: "Poster Pixelation",
            description:
                "A famous movie poster starts off as a blurry mess. Reveal it piece by piece and call the title before your eyes finally catch up.",
            iconSystemName: "photo.stack",
            color: .green
        ),
        3: GameMetadata(
            id: 3,
            name: "Emoji Plot Decoder",
            description:
                "Get a movie plot told only through a handful of emojis. Decode the chaos and guess the film before your brain turns into its own puzzle.",
            iconSystemName: "face.smiling",
            color: .red
        ),
        4: GameMetadata(
            id: 4,
            name: "Timeline Tangle",
            description:
                "Movies drop in totally scrambled order. Drag them into the correct timeline before your sense of film history short-circuits.",
            iconSystemName: "calendar",
            color: .yellow
        )
    ]

}
