//
//  FoundationModelsSynopsisRiddleGeneratorTests.swift
//  PopcornQuiz
//
//  Created by Adam Young on 05/12/2025.
//

import Foundation
import QuizDomain
import Testing

@testable import QuizInfrastructure

@Suite("FoundationModelsSynopsisRiddleGeneratorTests")
struct FoundationModelsSynopsisRiddleGeneratorTests {

    private let generator: FoundationModelsSynopsisRiddleGenerator

    init() {
        self.generator = FoundationModelsSynopsisRiddleGenerator()
    }

    @Test func testTheDarkKnightWithDarkCrypticTheme() async throws {
        let movie = Movie(
            id: 1,
            title: "The Dark Knight",
            overview:
                "Batman raises the stakes in his war on crime. With the help of Lt. Jim Gordon and District Attorney Harvey Dent, Batman sets out to dismantle the remaining criminal organizations that plague the streets. The partnership proves to be effective, but they soon find themselves prey to a reign of chaos unleashed by a rising criminal mastermind known to the terrified citizens of Gotham as the Joker.",
            posterPath: URL(string: "/qJ2tW6WMUDux911r6m7haRef0WH.jpg"),
            backdropPath: URL(string: "/dqK9Hag1054tghRQSqLSfrkvQnA.jpg")
        )
        let theme = QuizTheme.darkCryptic

        let riddle = try await generator.riddle(for: movie, theme: theme)

        print(riddle)
    }

    @Test func testTheDarkKnightWithDarkLegalese() async throws {
        let movie = Movie(
            id: 1,
            title: "The Dark Knight",
            overview:
                "Batman raises the stakes in his war on crime. With the help of Lt. Jim Gordon and District Attorney Harvey Dent, Batman sets out to dismantle the remaining criminal organizations that plague the streets. The partnership proves to be effective, but they soon find themselves prey to a reign of chaos unleashed by a rising criminal mastermind known to the terrified citizens of Gotham as the Joker.",
            posterPath: URL(string: "/qJ2tW6WMUDux911r6m7haRef0WH.jpg"),
            backdropPath: URL(string: "/dqK9Hag1054tghRQSqLSfrkvQnA.jpg")
        )
        let theme = QuizTheme.legalese

        let riddle = try await generator.riddle(for: movie, theme: theme)

        print(riddle)
    }

    @Test func testToyStoryWithDarkCrypticTheme() async throws {
        let movie = Movie(
            id: 1,
            title: "Zootopia",
            overview:
                "Determined to prove herself, Officer Judy Hopps, the first bunny on Zootopia's police force, jumps at the chance to crack her first case - even if it means partnering with scam-artist fox Nick Wilde to solve the mystery.",
            posterPath: URL(string: "/qJ2tW6WMUDux911r6m7haRef0WH.jpg"),
            backdropPath: URL(string: "/dqK9Hag1054tghRQSqLSfrkvQnA.jpg")
        )
        let theme = QuizTheme.child

        let riddle = try await generator.riddle(for: movie, theme: theme)

        print(riddle)
    }

}
