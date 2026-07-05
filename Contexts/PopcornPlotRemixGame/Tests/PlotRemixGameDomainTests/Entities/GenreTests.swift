//
//  GenreTests.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2026 Adam Young.
//

@testable import PlotRemixGameDomain
import Testing

@Suite("Genre")
struct GenreTests {

    @Test("init assigns provided id and name")
    func initAssignsProvidedValues() {
        let genre = Genre(id: 28, name: "Action")

        #expect(genre.id == 28)
        #expect(genre.name == "Action")
    }

    @Test("id conforms to Identifiable using the stored id")
    func identifiableUsesStoredID() {
        let genre = Genre(id: 35, name: "Comedy")

        #expect(genre.id == 35)
    }

    @Test("equality holds for genres with identical values")
    func equalityHoldsForIdenticalValues() {
        let first = Genre(id: 28, name: "Action")
        let second = Genre(id: 28, name: "Action")

        #expect(first == second)
    }

    @Test("equality fails when id differs")
    func equalityFailsWhenIDDiffers() {
        let first = Genre(id: 28, name: "Action")
        let second = Genre(id: 12, name: "Action")

        #expect(first != second)
    }

    @Test("equality fails when name differs")
    func equalityFailsWhenNameDiffers() {
        let first = Genre(id: 28, name: "Action")
        let second = Genre(id: 28, name: "Adventure")

        #expect(first != second)
    }

}
