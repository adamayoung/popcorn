//
//  TVSeriesPreviewMapperTests.swift
//  MediaSearchFeature
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation
@testable import MediaSearchFeature
import SearchApplication
import Testing

@Suite("TVSeriesPreviewMapper Tests")
struct TVSeriesPreviewMapperTests {

    private let mapper = TVSeriesPreviewMapper()

    @Test("Maps TVSeriesPreviewDetails to TVSeriesPreview")
    func mapsTVSeriesPreviewDetails() throws {
        let posterURLSet = try ImageURLSet(
            path: #require(URL(string: "https://example.com/path.jpg")),
            thumbnail: #require(URL(string: "https://example.com/thumbnail.jpg")),
            card: #require(URL(string: "https://example.com/card.jpg")),
            detail: #require(URL(string: "https://example.com/detail.jpg")),
            full: #require(URL(string: "https://example.com/full.jpg"))
        )

        let details = TVSeriesPreviewDetails(
            id: 1399,
            name: "Game of Thrones",
            overview: "A fantasy epic.",
            posterURLSet: posterURLSet
        )

        let result = mapper.map(details)

        #expect(result.id == 1399)
        #expect(result.name == "Game of Thrones")
        #expect(result.posterURL == URL(string: "https://example.com/thumbnail.jpg"))
    }

    @Test("Maps TVSeriesPreviewDetails with nil poster URL set")
    func mapsTVSeriesPreviewDetailsWithNilPosterURLSet() {
        let details = TVSeriesPreviewDetails(
            id: 123,
            name: "Test Series",
            overview: "Test overview"
        )

        let result = mapper.map(details)

        #expect(result.id == 123)
        #expect(result.name == "Test Series")
        #expect(result.posterURL == nil)
    }

    @Test("Maps multiple TV series previews correctly")
    func mapsMultipleTVSeriesPreviews() {
        let details1 = TVSeriesPreviewDetails(id: 1, name: "Series 1", overview: "Overview 1")
        let details2 = TVSeriesPreviewDetails(id: 2, name: "Series 2", overview: "Overview 2")

        let results = [details1, details2].map(mapper.map)

        #expect(results.count == 2)
        #expect(results[0].id == 1)
        #expect(results[0].name == "Series 1")
        #expect(results[1].id == 2)
        #expect(results[1].name == "Series 2")
    }

}
