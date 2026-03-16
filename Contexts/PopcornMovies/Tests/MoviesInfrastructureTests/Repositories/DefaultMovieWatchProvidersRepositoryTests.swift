//
//  DefaultMovieWatchProvidersRepositoryTests.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain
@testable import MoviesInfrastructure
import Testing

@Suite("DefaultMovieWatchProvidersRepository")
struct DefaultMovieWatchProvidersRepositoryTests {

    let mockRemoteDataSource: MockMovieRemoteDataSource

    init() {
        self.mockRemoteDataSource = MockMovieRemoteDataSource()
    }

    // MARK: - watchProviders() Tests

    @Test("watchProviders returns collection on success")
    func watchProvidersReturnsCollectionOnSuccess() async throws {
        let expectedCollection = try WatchProviderCollection(
            id: 550,
            link: #require(URL(string: "https://www.themoviedb.org/movie/550/watch")),
            streamingProviders: [WatchProvider(id: 8, name: "Netflix")]
        )
        mockRemoteDataSource.watchProvidersStub = .success(expectedCollection)

        let repository = makeRepository()

        let result = try await repository.watchProviders(forMovie: 550)

        let collection = try #require(result)
        #expect(collection.id == 550)
        #expect(collection.streamingProviders.count == 1)
    }

    @Test("watchProviders returns nil when remote returns nil")
    func watchProvidersReturnsNilWhenRemoteReturnsNil() async throws {
        mockRemoteDataSource.watchProvidersStub = .success(nil)

        let repository = makeRepository()

        let result = try await repository.watchProviders(forMovie: 550)

        #expect(result == nil)
    }

    @Test("watchProviders passes correct movie ID to remote data source")
    func watchProvidersPassesCorrectMovieID() async throws {
        mockRemoteDataSource.watchProvidersStub = .success(nil)

        let repository = makeRepository()

        _ = try await repository.watchProviders(forMovie: 999)

        #expect(mockRemoteDataSource.watchProvidersCallCount == 1)
        #expect(mockRemoteDataSource.watchProvidersCalledWith[0] == 999)
    }

    @Test("watchProviders throws not found when remote throws not found")
    func watchProvidersThrowsNotFoundWhenRemoteThrowsNotFound() async {
        mockRemoteDataSource.watchProvidersStub = .failure(.notFound)

        let repository = makeRepository()

        await #expect(
            performing: {
                try await repository.watchProviders(forMovie: 123)
            },
            throws: { error in
                guard let repoError = error as? MovieWatchProvidersRepositoryError else {
                    return false
                }
                if case .notFound = repoError {
                    return true
                }
                return false
            }
        )
    }

    @Test("watchProviders throws unauthorised when remote throws unauthorised")
    func watchProvidersThrowsUnauthorisedWhenRemoteThrowsUnauthorised() async {
        mockRemoteDataSource.watchProvidersStub = .failure(.unauthorised)

        let repository = makeRepository()

        await #expect(
            performing: {
                try await repository.watchProviders(forMovie: 123)
            },
            throws: { error in
                guard let repoError = error as? MovieWatchProvidersRepositoryError else {
                    return false
                }
                if case .unauthorised = repoError {
                    return true
                }
                return false
            }
        )
    }

    @Test("watchProviders throws unknown when remote throws unknown")
    func watchProvidersThrowsUnknownWhenRemoteThrowsUnknown() async {
        let underlyingError = NSError(domain: "test", code: 123)
        mockRemoteDataSource.watchProvidersStub = .failure(.unknown(underlyingError))

        let repository = makeRepository()

        await #expect(
            performing: {
                try await repository.watchProviders(forMovie: 123)
            },
            throws: { error in
                guard let repoError = error as? MovieWatchProvidersRepositoryError else {
                    return false
                }
                if case .unknown = repoError {
                    return true
                }
                return false
            }
        )
    }

    // MARK: - Helpers

    private func makeRepository() -> DefaultMovieWatchProvidersRepository {
        DefaultMovieWatchProvidersRepository(
            remoteDataSource: mockRemoteDataSource
        )
    }

}
