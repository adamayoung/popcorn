//
//  MoviePreviewMapperTests.swift
//  WatchlistFeature
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import MoviesApplication
import Testing
@testable import WatchlistFeature

@Suite("MoviePreviewMapper Tests")
struct MoviePreviewMapperTests {

    private let mapper = MoviePreviewMapper()

    @Test("Maps MoviePreviewDetails to MoviePreview")
    func mapsMoviePreviewDetails() throws {
        let posterURLSet = try ImageURLSet(
            path: #require(URL(string: "https://example.com/path.jpg")),
            thumbnail: #require(URL(string: "https://example.com/thumbnail.jpg")),
            card: #require(URL(string: "https://example.com/card.jpg")),
            detail: #require(URL(string: "https://example.com/detail.jpg")),
            full: #require(URL(string: "https://example.com/full.jpg"))
        )

        let details = MoviePreviewDetails(
            id: 798_645,
            title: "The Running Man",
            overview: "A thrilling action movie.",
            posterURLSet: posterURLSet
        )

        let result = mapper.map(details)

        #expect(result.id == 798_645)
        #expect(result.title == "The Running Man")
        #expect(result.posterURL == URL(string: "https://example.com/thumbnail.jpg"))
    }

    @Test("Maps MoviePreviewDetails with nil poster URL set")
    func mapsMoviePreviewDetailsWithNilPosterURLSet() {
        let details = MoviePreviewDetails(
            id: 123,
            title: "Test Movie",
            overview: "Test overview"
        )

        let result = mapper.map(details)

        #expect(result.id == 123)
        #expect(result.title == "Test Movie")
        #expect(result.posterURL == nil)
    }

}
