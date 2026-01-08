//
//  FoundationModelsSynopsisRiddleGeneratorTests.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import ObservabilityTestHelpers
import PlotRemixGameDomain
import Testing

@testable import PlotRemixGameInfrastructure

@Suite("FoundationModelsSynopsisRiddleGeneratorTests")
struct FoundationModelsSynopsisRiddleGeneratorTests {

    private let generator: FoundationModelsSynopsisRiddleGenerator
    private let mockObservability: MockObservability

    init() {
        self.mockObservability = MockObservability()
        self.generator = FoundationModelsSynopsisRiddleGenerator(observability: mockObservability)
    }

    @Test
    func theDarkKnightWithDarkCrypticTheme() async throws {
        // swiftlint:disable line_length
        let movie = Movie(
            id: 1,
            title: "The Dark Knight",
            overview:
            "Batman raises the stakes in his war on crime. With the help of Lt. Jim Gordon and District Attorney Harvey Dent, Batman sets out to dismantle the remaining criminal organizations that plague the streets. The partnership proves to be effective, but they soon find themselves prey to a reign of chaos unleashed by a rising criminal mastermind known to the terrified citizens of Gotham as the Joker.",
            posterPath: URL(string: "/qJ2tW6WMUDux911r6m7haRef0WH.jpg"),
            backdropPath: URL(string: "/dqK9Hag1054tghRQSqLSfrkvQnA.jpg")
        )
        // swiftlint:enable line_length
        let theme = GameTheme.darkCryptic

        let riddle = try await generator.riddle(for: movie, theme: theme)

        print(riddle)
    }

    @Test
    func theDarkKnightWithDarkLegalese() async throws {
        // swiftlint:disable line_length
        let movie = Movie(
            id: 1,
            title: "The Dark Knight",
            overview:
            "Batman raises the stakes in his war on crime. With the help of Lt. Jim Gordon and District Attorney Harvey Dent, Batman sets out to dismantle the remaining criminal organizations that plague the streets. The partnership proves to be effective, but they soon find themselves prey to a reign of chaos unleashed by a rising criminal mastermind known to the terrified citizens of Gotham as the Joker.",
            posterPath: URL(string: "/qJ2tW6WMUDux911r6m7haRef0WH.jpg"),
            backdropPath: URL(string: "/dqK9Hag1054tghRQSqLSfrkvQnA.jpg")
        )
        // swiftlint:enable line_length

        let theme = GameTheme.legalese

        let riddle = try await generator.riddle(for: movie, theme: theme)

        print(riddle)
    }

    @Test
    func toyStoryWithDarkCrypticTheme() async throws {
        // swiftlint:disable line_length
        let movie = Movie(
            id: 1,
            title: "Zootopia",
            overview:
            "Determined to prove herself, Officer Judy Hopps, the first bunny on Zootopia's police force, jumps at the chance to crack her first case - even if it means partnering with scam-artist fox Nick Wilde to solve the mystery.",
            posterPath: URL(string: "/qJ2tW6WMUDux911r6m7haRef0WH.jpg"),
            backdropPath: URL(string: "/dqK9Hag1054tghRQSqLSfrkvQnA.jpg")
        )
        // swiftlint:enable line_length

        let theme = GameTheme.child

        let riddle = try await generator.riddle(for: movie, theme: theme)

        print(riddle)
    }

}
