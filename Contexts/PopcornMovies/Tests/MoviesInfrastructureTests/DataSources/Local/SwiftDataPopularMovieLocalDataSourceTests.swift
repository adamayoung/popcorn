//
//  SwiftDataPopularMovieLocalDataSourceTests.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain
@testable import MoviesInfrastructure
import SwiftData
import Testing

@Suite("SwiftDataPopularMovieLocalDataSource")
struct SwiftDataPopularMovieLocalDataSourceTests {

    let modelContainer: ModelContainer

    init() throws {
        let schema = Schema([
            MoviesPopularMovieItemEntity.self,
            MoviesMoviePreviewEntity.self
        ])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        self.modelContainer = try ModelContainer(for: schema, configurations: [configuration])
    }

    // MARK: - popular() Tests

    @Test("popular returns nil when cache is empty")
    func popularReturnsNilWhenCacheIsEmpty() async throws {
        let dataSource = SwiftDataPopularMovieLocalDataSource(modelContainer: modelContainer)

        let result = try await dataSource.popular(page: 1)

        #expect(result == nil)
    }

    @Test("popular returns cached movies when available")
    func popularReturnsCachedMoviesWhenAvailable() async throws {
        let dataSource = SwiftDataPopularMovieLocalDataSource(modelContainer: modelContainer)
        let moviePreviews = MoviePreview.mocks

        try await dataSource.setPopular(page(moviePreviews))
        let result = try await dataSource.popular(page: 1)

        #expect(result != nil)
        #expect(result?.movies.count == moviePreviews.count)
    }

    @Test("popular round-trips the page metadata stored by setPopular")
    func popularRoundTripsPageMetadata() async throws {
        let dataSource = SwiftDataPopularMovieLocalDataSource(modelContainer: modelContainer)

        try await dataSource.setPopular(page(MoviePreview.mocks, page: 2, totalPages: 7))
        let result = try await dataSource.popular(page: 2)

        #expect(result?.page == 2)
        #expect(result?.totalPages == 7)
        #expect(result?.movies.count == MoviePreview.mocks.count)
    }

    @Test("popular treats a cached page with no totalPages (a pre-migration row) as a miss")
    func popularTreatsNilTotalPagesAsMiss() async throws {
        let dataSource = SwiftDataPopularMovieLocalDataSource(modelContainer: modelContainer)

        // Simulate a row written before `totalPages` was introduced: insert an item
        // entity with a nil totalPages directly into the shared in-memory store.
        let context = ModelContext(modelContainer)
        let previewEntity = MoviesMoviePreviewEntity(
            movieID: 1,
            title: "Legacy Movie",
            overview: ""
        )
        context.insert(previewEntity)
        let itemEntity = MoviesPopularMovieItemEntity(
            sortIndex: 0,
            page: 1,
            totalPages: nil,
            movie: previewEntity
        )
        context.insert(itemEntity)
        try context.save()

        let result = try await dataSource.popular(page: 1)

        #expect(result == nil)
    }

    @Test("popular returns nil for a different page")
    func popularReturnsNilForDifferentPage() async throws {
        let dataSource = SwiftDataPopularMovieLocalDataSource(modelContainer: modelContainer)

        try await dataSource.setPopular(page(MoviePreview.mocks))
        let result = try await dataSource.popular(page: 2)

        #expect(result == nil)
    }

    // MARK: - setPopular() Tests

    @Test("setPopular stores movies correctly")
    func setPopularStoresMoviesCorrectly() async throws {
        let dataSource = SwiftDataPopularMovieLocalDataSource(modelContainer: modelContainer)
        let moviePreviews = MoviePreview.mocks

        try await dataSource.setPopular(page(moviePreviews))
        let result = try await dataSource.popular(page: 1)

        #expect(result?.movies.count == moviePreviews.count)
        #expect(result?.movies[0].id == moviePreviews[0].id)
        #expect(result?.movies[0].title == moviePreviews[0].title)
    }

    @Test("setPopular replaces existing movies for the same page")
    func setPopularReplacesExistingMoviesForSamePage() async throws {
        let dataSource = SwiftDataPopularMovieLocalDataSource(modelContainer: modelContainer)
        let originalMovies = MoviePreview.mocks
        let newMovies = [MoviePreview.mock(id: 100, title: "New Movie")]

        try await dataSource.setPopular(page(originalMovies))
        try await dataSource.setPopular(page(newMovies))
        let result = try await dataSource.popular(page: 1)

        #expect(result?.movies.count == 1)
        #expect(result?.movies[0].id == 100)
        #expect(result?.movies[0].title == "New Movie")
    }

    @Test("setPopular deletes subsequent pages when setting an earlier page")
    func setPopularDeletesSubsequentPagesWhenSettingEarlierPage() async throws {
        let dataSource = SwiftDataPopularMovieLocalDataSource(modelContainer: modelContainer)

        try await dataSource.setPopular(page([MoviePreview.mock(id: 1, title: "Page 1")], page: 1))
        try await dataSource.setPopular(page([MoviePreview.mock(id: 2, title: "Page 2")], page: 2))
        try await dataSource.setPopular(page([MoviePreview.mock(id: 3, title: "Page 3")], page: 3))

        // Now set page 2 again - should delete page 2 and 3
        try await dataSource.setPopular(page([MoviePreview.mock(id: 20, title: "New Page 2")], page: 2))

        let page1Result = try await dataSource.popular(page: 1)
        let page2Result = try await dataSource.popular(page: 2)
        let page3Result = try await dataSource.popular(page: 3)

        #expect(page1Result?.movies.count == 1)
        #expect(page2Result?.movies.count == 1)
        #expect(page2Result?.movies[0].id == 20)
        #expect(page3Result == nil)
    }

    // MARK: - currentPopularStreamPage() Tests

    @Test("currentPopularStreamPage returns nil when no movies cached")
    func currentPopularStreamPageReturnsNilWhenNoMoviesCached() async throws {
        let dataSource = SwiftDataPopularMovieLocalDataSource(modelContainer: modelContainer)

        let result = try await dataSource.currentPopularStreamPage()

        #expect(result == nil)
    }

    @Test("currentPopularStreamPage returns the highest page number")
    func currentPopularStreamPageReturnsHighestPageNumber() async throws {
        let dataSource = SwiftDataPopularMovieLocalDataSource(modelContainer: modelContainer)

        try await dataSource.setPopular(page([MoviePreview.mock(id: 1)], page: 1))
        try await dataSource.setPopular(page([MoviePreview.mock(id: 2)], page: 2))
        try await dataSource.setPopular(page([MoviePreview.mock(id: 3)], page: 3))

        let result = try await dataSource.currentPopularStreamPage()

        #expect(result == 3)
    }

    // MARK: - Movie Data Integrity Tests

    @Test("popular preserves all movie fields")
    func popularPreservesAllMovieFields() async throws {
        let dataSource = SwiftDataPopularMovieLocalDataSource(modelContainer: modelContainer)
        let releaseDate = Date(timeIntervalSince1970: 1_000_000)
        let movie = MoviePreview(
            id: 42,
            title: "Test Title",
            overview: "Test Overview",
            releaseDate: releaseDate,
            posterPath: URL(string: "/poster.jpg"),
            backdropPath: URL(string: "/backdrop.jpg")
        )

        try await dataSource.setPopular(page([movie]))
        let result = try await dataSource.popular(page: 1)

        #expect(result?.movies.count == 1)
        let retrieved = try #require(result?.movies[0])
        #expect(retrieved.id == 42)
        #expect(retrieved.title == "Test Title")
        #expect(retrieved.overview == "Test Overview")
        #expect(retrieved.releaseDate == releaseDate)
        #expect(retrieved.posterPath == URL(string: "/poster.jpg"))
        #expect(retrieved.backdropPath == URL(string: "/backdrop.jpg"))
    }

    @Test("popular maintains sort order")
    func popularMaintainsSortOrder() async throws {
        let dataSource = SwiftDataPopularMovieLocalDataSource(modelContainer: modelContainer)
        let movies = [
            MoviePreview.mock(id: 1, title: "First"),
            MoviePreview.mock(id: 2, title: "Second"),
            MoviePreview.mock(id: 3, title: "Third")
        ]

        try await dataSource.setPopular(page(movies))
        let result = try await dataSource.popular(page: 1)

        #expect(result?.movies[0].id == 1)
        #expect(result?.movies[1].id == 2)
        #expect(result?.movies[2].id == 3)
    }

    // MARK: - Helpers

    private func page(
        _ movies: [MoviePreview],
        page: Int = 1,
        totalPages: Int = 1
    ) -> MoviePreviewPage {
        MoviePreviewPage(page: page, totalPages: totalPages, movies: movies)
    }

}
