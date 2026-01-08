//
//  StubGameRepository.swift
//  PopcornGamesCatalog
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import GamesCatalogDomain

public final class StubGameRepository: GameRepository, Sendable {

    public init() {}

    public func games() async throws(GameRepositoryError) -> [GameMetadata] {
        Self.games
    }

    public func game(id: Int) async throws(GameRepositoryError) -> GameMetadata {
        guard let game = Self.games.first(where: { $0.id == id }) else {
            throw .notFound
        }
        return game
    }

}

extension StubGameRepository {

    // MARK: - Games Data

    static let games: [GameMetadata] = [
        GameMetadata(
            id: 1,
            name: "Plot Remix",
            // swiftlint:disable:next line_length
            description: "Guess the movie from a remixed plot description. AI rewrites famous movie plots in creative styles.",
            iconSystemName: "theatermask.and.paintbrush",
            color: .blue
        ),
        GameMetadata(
            id: 2,
            name: "Movie Trivia",
            description: "Test your knowledge of movies with challenging trivia questions across all genres and eras.",
            iconSystemName: "questionmark.circle",
            color: .green
        ),
        GameMetadata(
            id: 3,
            name: "Cast Challenge",
            description: "Match actors to the movies they appeared in. How well do you know your favorite stars?",
            iconSystemName: "person.3",
            color: .red
        )
    ]

}
