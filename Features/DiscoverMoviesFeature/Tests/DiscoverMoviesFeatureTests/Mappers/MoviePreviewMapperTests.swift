//
//  MoviePreviewMapperTests.swift
//  DiscoverMoviesFeature
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import DiscoverApplication
@testable import DiscoverMoviesFeature
import Foundation
import Testing

@Suite("MoviePreviewMapper Tests")
struct MoviePreviewMapperTests {

    private let mapper = MoviePreviewMapper()

    @Test("Maps MoviePreviewDetails to MoviePreview using the card poster size")
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
            releaseDate: Date(timeIntervalSince1970: 0),
            genres: [],
            posterURLSet: posterURLSet
        )

        let result = mapper.map(details)

        #expect(result.id == 798_645)
        #expect(result.title == "The Running Man")
        #expect(result.posterURL == URL(string: "https://example.com/card.jpg"))
    }

    @Test("Maps MoviePreviewDetails with nil poster URL set")
    func mapsMoviePreviewDetailsWithNilPosterURLSet() {
        let details = MoviePreviewDetails(
            id: 123,
            title: "Test Movie",
            overview: "Test overview",
            releaseDate: Date(timeIntervalSince1970: 0),
            genres: []
        )

        let result = mapper.map(details)

        #expect(result.id == 123)
        #expect(result.title == "Test Movie")
        #expect(result.posterURL == nil)
    }

    @Test("Maps multiple movie previews correctly")
    func mapsMultipleMoviePreviews() {
        let details = (1 ... 3).map {
            MoviePreviewDetails(
                id: $0,
                title: "Movie \($0)",
                overview: "Overview \($0)",
                releaseDate: Date(timeIntervalSince1970: 0),
                genres: []
            )
        }

        let results = details.map(mapper.map)

        #expect(results.count == 3)
        #expect(results[0].id == 1)
        #expect(results[0].title == "Movie 1")
        #expect(results[2].id == 3)
    }

    @Test("Maps MoviePreviewDetailsPage preserving pagination metadata")
    func mapsMoviePreviewDetailsPage() {
        let detailsPage = MoviePreviewDetailsPage(
            page: 2,
            totalPages: 5,
            movies: [
                MoviePreviewDetails(
                    id: 1,
                    title: "Movie 1",
                    overview: "Overview 1",
                    releaseDate: Date(timeIntervalSince1970: 0),
                    genres: []
                ),
                MoviePreviewDetails(
                    id: 2,
                    title: "Movie 2",
                    overview: "Overview 2",
                    releaseDate: Date(timeIntervalSince1970: 0),
                    genres: []
                )
            ]
        )

        let result = mapper.map(detailsPage)

        #expect(result.page == 2)
        #expect(result.totalPages == 5)
        #expect(result.movies.count == 2)
        #expect(result.movies[0].id == 1)
        #expect(result.movies[1].id == 2)
    }

}
