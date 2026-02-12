//
//  PersonPreviewMapperTests.swift
//  ExploreFeature
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
@testable import ExploreFeature
import Foundation
import Testing
import TrendingApplication

@Suite("PersonPreviewMapper Tests")
struct PersonPreviewMapperTests {

    private let mapper = PersonPreviewMapper()

    @Test("Maps PersonPreviewDetails to PersonPreview")
    func mapsPersonPreviewDetails() throws {
        let profileURLSet = try ImageURLSet(
            path: #require(URL(string: "https://example.com/path.jpg")),
            thumbnail: #require(URL(string: "https://example.com/thumbnail.jpg")),
            card: #require(URL(string: "https://example.com/card.jpg")),
            detail: #require(URL(string: "https://example.com/detail.jpg")),
            full: #require(URL(string: "https://example.com/full.jpg"))
        )

        let details = PersonPreviewDetails(
            id: 83271,
            name: "Glen Powell",
            knownForDepartment: "Acting",
            gender: .male,
            profileURLSet: profileURLSet
        )

        let result = mapper.map(details)

        #expect(result.id == 83271)
        #expect(result.name == "Glen Powell")
        #expect(result.profileURL == URL(string: "https://example.com/detail.jpg"))
    }

    @Test("Maps PersonPreviewDetails with nil profile URL set")
    func mapsPersonPreviewDetailsWithNilProfileURLSet() {
        let details = PersonPreviewDetails(
            id: 123,
            name: "Test Person",
            gender: .unknown
        )

        let result = mapper.map(details)

        #expect(result.id == 123)
        #expect(result.name == "Test Person")
        #expect(result.profileURL == nil)
    }

    @Test("Maps multiple person previews correctly")
    func mapsMultiplePersonPreviews() {
        let details1 = PersonPreviewDetails(id: 1, name: "Person 1", gender: .male)
        let details2 = PersonPreviewDetails(id: 2, name: "Person 2", gender: .female)
        let details3 = PersonPreviewDetails(id: 3, name: "Person 3", gender: .other)

        let results = [details1, details2, details3].map(mapper.map)

        #expect(results.count == 3)
        #expect(results[0].id == 1)
        #expect(results[0].name == "Person 1")
        #expect(results[1].id == 2)
        #expect(results[1].name == "Person 2")
        #expect(results[2].id == 3)
        #expect(results[2].name == "Person 3")
    }

}
