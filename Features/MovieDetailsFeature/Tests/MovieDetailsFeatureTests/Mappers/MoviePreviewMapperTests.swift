//
//  MoviePreviewMapperTests.swift
//  MovieDetailsFeature
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation
import MoviesApplication
import Testing

@testable import MovieDetailsFeature

@Suite("MoviePreviewMapper Tests")
struct MoviePreviewMapperTests {

    private let mapper = MoviePreviewMapper()

    @Test("Maps all properties from MoviePreviewDetails to MoviePreview")
    func mapsAllProperties() throws {
        let posterURLSet = try ImageURLSet(
            path: #require(URL(string: "https://example.com/poster-path.jpg")),
            thumbnail: #require(URL(string: "https://example.com/poster-thumbnail.jpg")),
            card: #require(URL(string: "https://example.com/poster-card.jpg")),
            detail: #require(URL(string: "https://example.com/poster-detail.jpg")),
            full: #require(URL(string: "https://example.com/poster-full.jpg"))
        )
        let backdropURLSet = try ImageURLSet(
            path: #require(URL(string: "https://example.com/backdrop-path.jpg")),
            thumbnail: #require(URL(string: "https://example.com/backdrop-thumbnail.jpg")),
            card: #require(URL(string: "https://example.com/backdrop-card.jpg")),
            detail: #require(URL(string: "https://example.com/backdrop-detail.jpg")),
            full: #require(URL(string: "https://example.com/backdrop-full.jpg"))
        )
        let logoURLSet = try ImageURLSet(
            path: #require(URL(string: "https://example.com/logo-path.jpg")),
            thumbnail: #require(URL(string: "https://example.com/logo-thumbnail.jpg")),
            card: #require(URL(string: "https://example.com/logo-card.jpg")),
            detail: #require(URL(string: "https://example.com/logo-detail.jpg")),
            full: #require(URL(string: "https://example.com/logo-full.jpg"))
        )

        let moviePreviewDetails = MoviePreviewDetails(
            id: 798_645,
            title: "The Running Man",
            overview: "A thrilling action movie.",
            posterURLSet: posterURLSet,
            backdropURLSet: backdropURLSet,
            logoURLSet: logoURLSet
        )

        let result = mapper.map(moviePreviewDetails)

        #expect(result.id == 798_645)
        #expect(result.title == "The Running Man")
        #expect(result.posterURL == URL(string: "https://example.com/poster-detail.jpg"))
        #expect(result.backdropURL == URL(string: "https://example.com/backdrop-detail.jpg"))
        #expect(result.logoURL == URL(string: "https://example.com/logo-thumbnail.jpg"))
    }

    @Test("Maps with nil optional URL sets")
    func mapsWithNilOptionalURLSets() {
        let moviePreviewDetails = MoviePreviewDetails(
            id: 123,
            title: "Test Movie",
            overview: "Test overview",
            posterURLSet: nil,
            backdropURLSet: nil,
            logoURLSet: nil
        )

        let result = mapper.map(moviePreviewDetails)

        #expect(result.id == 123)
        #expect(result.title == "Test Movie")
        #expect(result.posterURL == nil)
        #expect(result.backdropURL == nil)
        #expect(result.logoURL == nil)
    }

    @Test("Extracts correct URL sizes from ImageURLSets")
    func extractsCorrectURLSizes() throws {
        let posterURLSet = try ImageURLSet(
            path: #require(URL(string: "https://example.com/poster-path.jpg")),
            thumbnail: #require(URL(string: "https://example.com/poster-thumbnail.jpg")),
            card: #require(URL(string: "https://example.com/poster-card.jpg")),
            detail: #require(URL(string: "https://example.com/poster-detail.jpg")),
            full: #require(URL(string: "https://example.com/poster-full.jpg"))
        )
        let logoURLSet = try ImageURLSet(
            path: #require(URL(string: "https://example.com/logo-path.jpg")),
            thumbnail: #require(URL(string: "https://example.com/logo-thumbnail.jpg")),
            card: #require(URL(string: "https://example.com/logo-card.jpg")),
            detail: #require(URL(string: "https://example.com/logo-detail.jpg")),
            full: #require(URL(string: "https://example.com/logo-full.jpg"))
        )

        let moviePreviewDetails = MoviePreviewDetails(
            id: 456,
            title: "Test Movie",
            overview: "Test overview",
            posterURLSet: posterURLSet,
            backdropURLSet: nil,
            logoURLSet: logoURLSet
        )

        let result = mapper.map(moviePreviewDetails)

        // Poster uses detail size
        #expect(result.posterURL == posterURLSet.detail)
        // Logo uses thumbnail size
        #expect(result.logoURL == logoURLSet.thumbnail)
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
