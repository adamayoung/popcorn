//
//  MoviePreviewMapperTests.swift
//  PopcornSearchAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import PopcornSearchAdapters
import SearchDomain
import Testing
import TMDb

@Suite("MoviePreviewMapper Tests")
struct MoviePreviewMapperTests {

    @Test("map converts TMDb MovieListItem to MoviePreview with all fields")
    func mapConvertsTMDbMovieListItemToMoviePreviewWithAllFields() throws {
        let posterPath = try #require(URL(string: "https://tmdb.example/poster.jpg"))
        let backdropPath = try #require(URL(string: "https://tmdb.example/backdrop.jpg"))
        let movieListItem = MovieListItem(
            id: 123,
            title: "Test Movie",
            originalTitle: "Test Movie Original",
            originalLanguage: "en",
            overview: "A test movie overview",
            genreIDs: [28, 12],
            releaseDate: Date(timeIntervalSince1970: 1_600_000_000),
            posterPath: posterPath,
            backdropPath: backdropPath,
            popularity: 100.5,
            voteAverage: 8.5,
            voteCount: 1000,
            hasVideo: true,
            isAdultOnly: false
        )

        let mapper = MoviePreviewMapper()
        let result = mapper.map(movieListItem)

        #expect(result.id == 123)
        #expect(result.title == "Test Movie")
        #expect(result.overview == "A test movie overview")
        #expect(result.posterPath == posterPath)
        #expect(result.backdropPath == backdropPath)
    }

    @Test("map converts TMDb MovieListItem with nil optional fields")
    func mapConvertsTMDbMovieListItemWithNilOptionalFields() {
        let movieListItem = MovieListItem(
            id: 456,
            title: "Minimal Movie",
            originalTitle: "Minimal Movie",
            originalLanguage: "en",
            overview: "A minimal movie",
            genreIDs: [],
            releaseDate: nil,
            posterPath: nil,
            backdropPath: nil
        )

        let mapper = MoviePreviewMapper()
        let result = mapper.map(movieListItem)

        #expect(result.id == 456)
        #expect(result.title == "Minimal Movie")
        #expect(result.overview == "A minimal movie")
        #expect(result.posterPath == nil)
        #expect(result.backdropPath == nil)
    }

}
