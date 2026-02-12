//
//  DefaultDiscoverMovieRepositoryTests.swift
//  PopcornDiscover
//
//  Copyright © 2025 Adam Young.
//

import DiscoverDomain
@testable import DiscoverInfrastructure
import Foundation
import ObservabilityTestHelpers
import Testing

@Suite("DefaultDiscoverMovieRepository")
struct DefaultDiscoverMovieRepositoryTests {

    let mockRemoteDataSource: MockDiscoverRemoteDataSource
    let mockLocalDataSource: MockDiscoverMovieLocalDataSource

    init() {
        self.mockRemoteDataSource = MockDiscoverRemoteDataSource()
        self.mockLocalDataSource = MockDiscoverMovieLocalDataSource()
    }

    // MARK: - Cache Hit Tests

    @Test("movies returns cached value when available")
    func moviesReturnsCachedValueWhenAvailable() async throws {
        let cachedMovies = MoviePreview.mocks
        mockLocalDataSource.moviesStub = .success(cachedMovies)

        let repository = makeRepository()

        let result = try await repository.movies(filter: nil, page: 1)

        #expect(result.count == cachedMovies.count)
        #expect(await mockLocalDataSource.moviesCallCount == 1)
        #expect(mockRemoteDataSource.moviesCallCount == 0)
    }

    @Test("movies with filter returns cached value when available")
    func moviesWithFilterReturnsCachedValueWhenAvailable() async throws {
        let cachedMovies = MoviePreview.mocks
        let filter = MovieFilter(originalLanguage: "en", genres: [28])
        mockLocalDataSource.moviesStub = .success(cachedMovies)

        let repository = makeRepository()

        let result = try await repository.movies(filter: filter, page: 1)

        #expect(result.count == cachedMovies.count)
        #expect(await mockLocalDataSource.moviesCallCount == 1)
        let calledWith = await mockLocalDataSource.moviesCalledWith
        #expect(calledWith[0].filter?.originalLanguage == "en")
        #expect(mockRemoteDataSource.moviesCallCount == 0)
    }

    // MARK: - Cache Miss Tests

    @Test("movies fetches from remote when cache is empty")
    func moviesFetchesFromRemoteWhenCacheIsEmpty() async throws {
        let remoteMovies = MoviePreview.mocks
        mockLocalDataSource.moviesStub = .success(nil)
        mockRemoteDataSource.moviesStub = .success(remoteMovies)

        let repository = makeRepository()

        let result = try await repository.movies(filter: nil, page: 1)

        #expect(result.count == remoteMovies.count)
        #expect(await mockLocalDataSource.moviesCallCount == 1)
        #expect(mockRemoteDataSource.moviesCallCount == 1)
    }

    @Test("movies caches remote value after fetching")
    func moviesCachesRemoteValueAfterFetching() async throws {
        let remoteMovies = MoviePreview.mocks
        mockLocalDataSource.moviesStub = .success(nil)
        mockRemoteDataSource.moviesStub = .success(remoteMovies)

        let repository = makeRepository()

        _ = try await repository.movies(filter: nil, page: 1)

        #expect(await mockLocalDataSource.setMoviesCallCount == 1)
        let setMoviesCalledWith = await mockLocalDataSource.setMoviesCalledWith
        #expect(setMoviesCalledWith[0].movies.count == remoteMovies.count)
        #expect(setMoviesCalledWith[0].page == 1)
    }

    @Test("movies passes filter and page to cache when storing")
    func moviesPassesFilterAndPageToCacheWhenStoring() async throws {
        let remoteMovies = MoviePreview.mocks
        let filter = MovieFilter(originalLanguage: "fr", genres: [35])
        mockLocalDataSource.moviesStub = .success(nil)
        mockRemoteDataSource.moviesStub = .success(remoteMovies)

        let repository = makeRepository()

        _ = try await repository.movies(filter: filter, page: 3)

        let setMoviesCalledWith = await mockLocalDataSource.setMoviesCalledWith
        #expect(setMoviesCalledWith[0].filter?.originalLanguage == "fr")
        #expect(setMoviesCalledWith[0].page == 3)
    }

    // MARK: - Error Tests

    @Test("movies throws error when local data source fails")
    func moviesThrowsErrorWhenLocalDataSourceFails() async {
        let underlyingError = NSError(domain: "test", code: 123)
        mockLocalDataSource.moviesStub = .failure(.persistence(underlyingError))

        let repository = makeRepository()

        await #expect(
            performing: {
                try await repository.movies(filter: nil, page: 1)
            },
            throws: { error in
                guard let repoError = error as? DiscoverMovieRepositoryError else {
                    return false
                }
                if case .unknown = repoError {
                    return true
                }
                return false
            }
        )
    }

    @Test("movies throws unauthorised error when remote throws unauthorised")
    func moviesThrowsUnauthorisedErrorWhenRemoteThrowsUnauthorised() async {
        mockLocalDataSource.moviesStub = .success(nil)
        mockRemoteDataSource.moviesStub = .failure(.unauthorised)

        let repository = makeRepository()

        await #expect(
            performing: {
                try await repository.movies(filter: nil, page: 1)
            },
            throws: { error in
                guard let repoError = error as? DiscoverMovieRepositoryError else {
                    return false
                }
                if case .unauthorised = repoError {
                    return true
                }
                return false
            }
        )
    }

    @Test("movies throws unknown error when remote throws unknown")
    func moviesThrowsUnknownErrorWhenRemoteThrowsUnknown() async {
        let underlyingError = NSError(domain: "test", code: 456)
        mockLocalDataSource.moviesStub = .success(nil)
        mockRemoteDataSource.moviesStub = .failure(.unknown(underlyingError))

        let repository = makeRepository()

        await #expect(
            performing: {
                try await repository.movies(filter: nil, page: 1)
            },
            throws: { error in
                guard let repoError = error as? DiscoverMovieRepositoryError else {
                    return false
                }
                if case .unknown = repoError {
                    return true
                }
                return false
            }
        )
    }

    @Test("movies throws error when cache save fails")
    func moviesThrowsErrorWhenCacheSaveFails() async {
        let remoteMovies = MoviePreview.mocks
        let saveError = NSError(domain: "test", code: 789)
        mockLocalDataSource.moviesStub = .success(nil)
        mockRemoteDataSource.moviesStub = .success(remoteMovies)
        mockLocalDataSource.setMoviesStub = .failure(.persistence(saveError))

        let repository = makeRepository()

        await #expect(
            performing: {
                try await repository.movies(filter: nil, page: 1)
            },
            throws: { error in
                guard let repoError = error as? DiscoverMovieRepositoryError else {
                    return false
                }
                if case .unknown = repoError {
                    return true
                }
                return false
            }
        )
    }

    // MARK: - Pagination Tests

    @Test("movies passes correct page to data sources")
    func moviesPassesCorrectPageToDataSources() async throws {
        let remoteMovies = MoviePreview.mocks
        mockLocalDataSource.moviesStub = .success(nil)
        mockRemoteDataSource.moviesStub = .success(remoteMovies)

        let repository = makeRepository()

        _ = try await repository.movies(filter: nil, page: 5)

        let localCalledWith = await mockLocalDataSource.moviesCalledWith
        #expect(localCalledWith[0].page == 5)
        #expect(mockRemoteDataSource.moviesCalledWith[0].page == 5)
    }

    // MARK: - No Span Tests

    @Test("movies works without span")
    func moviesWorksWithoutSpan() async throws {
        let cachedMovies = MoviePreview.mocks
        mockLocalDataSource.moviesStub = .success(cachedMovies)

        SpanContext.provider = nil

        let repository = makeRepository()

        let result = try await repository.movies(filter: nil, page: 1)

        #expect(result.count == cachedMovies.count)
    }

    // MARK: - Helpers

    private func makeRepository() -> DefaultDiscoverMovieRepository {
        DefaultDiscoverMovieRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource
        )
    }

}
