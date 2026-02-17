//
//  SwiftDataDiscoverMovieLocalDataSourceTests.swift
//  PopcornDiscover
//
//  Copyright © 2026 Adam Young.
//

import DiscoverDomain
@testable import DiscoverInfrastructure
import Foundation
import SwiftData
import Testing

@Suite("SwiftDataDiscoverMovieLocalDataSource")
struct SwiftDataDiscoverMovieLocalDataSourceTests {

    let modelContainer: ModelContainer

    init() throws {
        let schema = Schema([
            DiscoverMovieItemEntity.self,
            DiscoverMoviePreviewEntity.self
        ])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        self.modelContainer = try ModelContainer(for: schema, configurations: [configuration])
    }

    // MARK: - movies() Tests

    @Test("movies returns nil when cache is empty")
    func moviesReturnsNilWhenCacheIsEmpty() async throws {
        let dataSource = SwiftDataDiscoverMovieLocalDataSource(modelContainer: modelContainer)

        let result = try await dataSource.movies(filter: nil, page: 1)

        #expect(result == nil)
    }

    @Test("movies returns cached movies when available")
    func moviesReturnsCachedMoviesWhenAvailable() async throws {
        let dataSource = SwiftDataDiscoverMovieLocalDataSource(modelContainer: modelContainer)
        let moviePreviews = MoviePreview.mocks

        try await dataSource.setMovies(moviePreviews, filter: nil, page: 1)
        let result = try await dataSource.movies(filter: nil, page: 1)

        #expect(result != nil)
        #expect(result?.count == moviePreviews.count)
    }

    @Test("movies returns nil for different page")
    func moviesReturnsNilForDifferentPage() async throws {
        let dataSource = SwiftDataDiscoverMovieLocalDataSource(modelContainer: modelContainer)
        let moviePreviews = MoviePreview.mocks

        try await dataSource.setMovies(moviePreviews, filter: nil, page: 1)
        let result = try await dataSource.movies(filter: nil, page: 2)

        #expect(result == nil)
    }

    @Test("movies returns nil for different filter")
    func moviesReturnsNilForDifferentFilter() async throws {
        let dataSource = SwiftDataDiscoverMovieLocalDataSource(modelContainer: modelContainer)
        let moviePreviews = MoviePreview.mocks
        let filter = MovieFilter(originalLanguage: "en", genres: nil)

        try await dataSource.setMovies(moviePreviews, filter: nil, page: 1)
        let result = try await dataSource.movies(filter: filter, page: 1)

        #expect(result == nil)
    }

    @Test("movies returns cached movies for matching filter")
    func moviesReturnsCachedMoviesForMatchingFilter() async throws {
        let dataSource = SwiftDataDiscoverMovieLocalDataSource(modelContainer: modelContainer)
        let moviePreviews = MoviePreview.mocks
        let filter = MovieFilter(originalLanguage: "en", genres: [28])

        try await dataSource.setMovies(moviePreviews, filter: filter, page: 1)
        let result = try await dataSource.movies(filter: filter, page: 1)

        #expect(result != nil)
        #expect(result?.count == moviePreviews.count)
    }

    // MARK: - setMovies() Tests

    @Test("setMovies stores movies correctly")
    func setMoviesStoresMoviesCorrectly() async throws {
        let dataSource = SwiftDataDiscoverMovieLocalDataSource(modelContainer: modelContainer)
        let moviePreviews = MoviePreview.mocks

        try await dataSource.setMovies(moviePreviews, filter: nil, page: 1)
        let result = try await dataSource.movies(filter: nil, page: 1)

        #expect(result?.count == moviePreviews.count)
        #expect(result?[0].id == moviePreviews[0].id)
        #expect(result?[0].title == moviePreviews[0].title)
    }

    @Test("setMovies replaces existing movies for same page")
    func setMoviesReplacesExistingMoviesForSamePage() async throws {
        let dataSource = SwiftDataDiscoverMovieLocalDataSource(modelContainer: modelContainer)
        let originalMovies = MoviePreview.mocks
        let newMovies = [MoviePreview.mock(id: 100, title: "New Movie")]

        try await dataSource.setMovies(originalMovies, filter: nil, page: 1)
        try await dataSource.setMovies(newMovies, filter: nil, page: 1)
        let result = try await dataSource.movies(filter: nil, page: 1)

        #expect(result?.count == 1)
        #expect(result?[0].id == 100)
        #expect(result?[0].title == "New Movie")
    }

    @Test("setMovies deletes subsequent pages when setting earlier page")
    func setMoviesDeletesSubsequentPagesWhenSettingEarlierPage() async throws {
        let dataSource = SwiftDataDiscoverMovieLocalDataSource(modelContainer: modelContainer)
        let page1Movies = [MoviePreview.mock(id: 1, title: "Page 1")]
        let page2Movies = [MoviePreview.mock(id: 2, title: "Page 2")]
        let page3Movies = [MoviePreview.mock(id: 3, title: "Page 3")]

        try await dataSource.setMovies(page1Movies, filter: nil, page: 1)
        try await dataSource.setMovies(page2Movies, filter: nil, page: 2)
        try await dataSource.setMovies(page3Movies, filter: nil, page: 3)

        // Now set page 2 again - should delete page 2 and 3
        let newPage2Movies = [MoviePreview.mock(id: 20, title: "New Page 2")]
        try await dataSource.setMovies(newPage2Movies, filter: nil, page: 2)

        let page1Result = try await dataSource.movies(filter: nil, page: 1)
        let page2Result = try await dataSource.movies(filter: nil, page: 2)
        let page3Result = try await dataSource.movies(filter: nil, page: 3)

        #expect(page1Result?.count == 1)
        #expect(page2Result?.count == 1)
        #expect(page2Result?[0].id == 20)
        #expect(page3Result == nil)
    }

    @Test("setMovies with different filters stores separately")
    func setMoviesWithDifferentFiltersStoresSeparately() async throws {
        let dataSource = SwiftDataDiscoverMovieLocalDataSource(modelContainer: modelContainer)
        let noFilterMovies = [MoviePreview.mock(id: 1, title: "No Filter")]
        let filterMovies = [MoviePreview.mock(id: 2, title: "With Filter")]
        let filter = MovieFilter(originalLanguage: "en", genres: nil)

        try await dataSource.setMovies(noFilterMovies, filter: nil, page: 1)
        try await dataSource.setMovies(filterMovies, filter: filter, page: 1)

        let noFilterResult = try await dataSource.movies(filter: nil, page: 1)
        let filterResult = try await dataSource.movies(filter: filter, page: 1)

        #expect(noFilterResult?.count == 1)
        #expect(noFilterResult?[0].id == 1)
        #expect(filterResult?.count == 1)
        #expect(filterResult?[0].id == 2)
    }

    // MARK: - currentMoviesStreamPage() Tests

    @Test("currentMoviesStreamPage returns nil when no movies cached")
    func currentMoviesStreamPageReturnsNilWhenNoMoviesCached() async throws {
        let dataSource = SwiftDataDiscoverMovieLocalDataSource(modelContainer: modelContainer)

        let result = try await dataSource.currentMoviesStreamPage(filter: nil)

        #expect(result == nil)
    }

    @Test("currentMoviesStreamPage returns highest page number")
    func currentMoviesStreamPageReturnsHighestPageNumber() async throws {
        let dataSource = SwiftDataDiscoverMovieLocalDataSource(modelContainer: modelContainer)

        try await dataSource.setMovies([MoviePreview.mock(id: 1)], filter: nil, page: 1)
        try await dataSource.setMovies([MoviePreview.mock(id: 2)], filter: nil, page: 2)
        try await dataSource.setMovies([MoviePreview.mock(id: 3)], filter: nil, page: 3)

        let result = try await dataSource.currentMoviesStreamPage(filter: nil)

        #expect(result == 3)
    }

    @Test("currentMoviesStreamPage respects filter")
    func currentMoviesStreamPageRespectsFilter() async throws {
        let dataSource = SwiftDataDiscoverMovieLocalDataSource(modelContainer: modelContainer)
        let filter = MovieFilter(originalLanguage: "fr", genres: nil)

        try await dataSource.setMovies([MoviePreview.mock(id: 1)], filter: nil, page: 5)
        try await dataSource.setMovies([MoviePreview.mock(id: 2)], filter: filter, page: 2)

        let noFilterResult = try await dataSource.currentMoviesStreamPage(filter: nil)
        let filterResult = try await dataSource.currentMoviesStreamPage(filter: filter)

        #expect(noFilterResult == 5)
        #expect(filterResult == 2)
    }

    // MARK: - Movie Data Integrity Tests

    @Test("movies preserves all movie fields")
    func moviesPreservesAllMovieFields() async throws {
        let dataSource = SwiftDataDiscoverMovieLocalDataSource(modelContainer: modelContainer)
        let releaseDate = Date(timeIntervalSince1970: 1_000_000)
        let movie = MoviePreview(
            id: 42,
            title: "Test Title",
            overview: "Test Overview",
            releaseDate: releaseDate,
            genreIDs: [28, 12, 35],
            posterPath: URL(string: "/poster.jpg"),
            backdropPath: URL(string: "/backdrop.jpg")
        )

        try await dataSource.setMovies([movie], filter: nil, page: 1)
        let result = try await dataSource.movies(filter: nil, page: 1)

        #expect(result?.count == 1)
        let retrieved = try #require(result?[0])
        #expect(retrieved.id == 42)
        #expect(retrieved.title == "Test Title")
        #expect(retrieved.overview == "Test Overview")
        #expect(retrieved.releaseDate == releaseDate)
        #expect(retrieved.genreIDs == [28, 12, 35])
        #expect(retrieved.posterPath == URL(string: "/poster.jpg"))
        #expect(retrieved.backdropPath == URL(string: "/backdrop.jpg"))
    }

    @Test("movies maintains sort order")
    func moviesMaintainsSortOrder() async throws {
        let dataSource = SwiftDataDiscoverMovieLocalDataSource(modelContainer: modelContainer)
        let movies = [
            MoviePreview.mock(id: 1, title: "First"),
            MoviePreview.mock(id: 2, title: "Second"),
            MoviePreview.mock(id: 3, title: "Third")
        ]

        try await dataSource.setMovies(movies, filter: nil, page: 1)
        let result = try await dataSource.movies(filter: nil, page: 1)

        #expect(result?[0].id == 1)
        #expect(result?[1].id == 2)
        #expect(result?[2].id == 3)
    }

}
