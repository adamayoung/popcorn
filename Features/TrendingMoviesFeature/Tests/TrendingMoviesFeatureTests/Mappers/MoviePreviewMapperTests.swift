//
//  MoviePreviewMapperTests.swift
//  TrendingMoviesFeature
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import Testing
import TrendingApplication
@testable import TrendingMoviesFeature

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

    @Test("Maps multiple movie previews correctly")
    func mapsMultipleMoviePreviews() {
        let details1 = MoviePreviewDetails(id: 1, title: "Movie 1", overview: "Overview 1")
        let details2 = MoviePreviewDetails(id: 2, title: "Movie 2", overview: "Overview 2")
        let details3 = MoviePreviewDetails(id: 3, title: "Movie 3", overview: "Overview 3")

        let results = [details1, details2, details3].map(mapper.map)

        #expect(results.count == 3)
        #expect(results[0].id == 1)
        #expect(results[0].title == "Movie 1")
        #expect(results[1].id == 2)
        #expect(results[1].title == "Movie 2")
        #expect(results[2].id == 3)
        #expect(results[2].title == "Movie 3")
    }

}
