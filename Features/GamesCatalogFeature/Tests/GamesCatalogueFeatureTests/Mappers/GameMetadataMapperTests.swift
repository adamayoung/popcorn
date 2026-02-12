//
//  GameMetadataMapperTests.swift
//  GamesCatalogFeature
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import GamesCatalogDomain
@testable import GamesCatalogFeature
import SwiftUI
import Testing

@Suite("GameMetadataMapper Tests")
struct GameMetadataMapperTests {

    private let mapper = GameMetadataMapper()

    @Test("Maps GameMetadata with all properties")
    func mapsGameMetadataWithAllProperties() {
        let domainMetadata = GamesCatalogDomain.GameMetadata(
            id: 1,
            name: "Plot Remix",
            description: "Decode the twisted summary and guess the film.",
            iconSystemName: "movieclapper",
            color: .blue
        )

        let result = mapper.map(domainMetadata)

        #expect(result.id == 1)
        #expect(result.name == "Plot Remix")
        #expect(result.description == "Decode the twisted summary and guess the film.")
        #expect(result.iconSystemName == "movieclapper")
        #expect(result.color == .blue)
    }

    @Test("Maps blue color correctly")
    func mapsBlueColor() {
        let domainMetadata = GamesCatalogDomain.GameMetadata(
            id: 1,
            name: "Test",
            description: "Test",
            iconSystemName: "star",
            color: .blue
        )

        let result = mapper.map(domainMetadata)

        #expect(result.color == .blue)
    }

    @Test("Maps green color correctly")
    func mapsGreenColor() {
        let domainMetadata = GamesCatalogDomain.GameMetadata(
            id: 2,
            name: "Test",
            description: "Test",
            iconSystemName: "star",
            color: .green
        )

        let result = mapper.map(domainMetadata)

        #expect(result.color == .green)
    }

    @Test("Maps red color correctly")
    func mapsRedColor() {
        let domainMetadata = GamesCatalogDomain.GameMetadata(
            id: 3,
            name: "Test",
            description: "Test",
            iconSystemName: "star",
            color: .red
        )

        let result = mapper.map(domainMetadata)

        #expect(result.color == .red)
    }

    @Test("Maps yellow color correctly")
    func mapsYellowColor() {
        let domainMetadata = GamesCatalogDomain.GameMetadata(
            id: 4,
            name: "Test",
            description: "Test",
            iconSystemName: "star",
            color: .yellow
        )

        let result = mapper.map(domainMetadata)

        #expect(result.color == .yellow)
    }

    @Test("Maps multiple game metadata correctly")
    func mapsMultipleGameMetadata() {
        let metadata1 = GamesCatalogDomain.GameMetadata(
            id: 1,
            name: "Game 1",
            description: "Description 1",
            iconSystemName: "icon1",
            color: .blue
        )
        let metadata2 = GamesCatalogDomain.GameMetadata(
            id: 2,
            name: "Game 2",
            description: "Description 2",
            iconSystemName: "icon2",
            color: .green
        )

        let results = [metadata1, metadata2].map(mapper.map)

        #expect(results.count == 2)
        #expect(results[0].id == 1)
        #expect(results[0].name == "Game 1")
        #expect(results[0].color == .blue)
        #expect(results[1].id == 2)
        #expect(results[1].name == "Game 2")
        #expect(results[1].color == .green)
    }

}
