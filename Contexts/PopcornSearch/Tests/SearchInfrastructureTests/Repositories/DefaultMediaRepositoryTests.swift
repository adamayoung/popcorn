//
//  DefaultMediaRepositoryTests.swift
//  PopcornSearch
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import SearchDomain
@testable import SearchInfrastructure
import Testing

@Suite("DefaultMediaRepository")
struct DefaultMediaRepositoryTests {

    let mockRemoteDataSource: MockMediaRemoteDataSource
    let mockLocalDataSource: MockMediaLocalDataSource

    init() {
        self.mockRemoteDataSource = MockMediaRemoteDataSource()
        self.mockLocalDataSource = MockMediaLocalDataSource()
    }

    // MARK: - search() Tests

    @Test("search returns media from remote data source")
    func searchReturnsMediaFromRemoteDataSource() async throws {
        let expectedMedia = MediaPreview.mocks
        mockRemoteDataSource.searchStub = .success(expectedMedia)

        let repository = makeRepository()

        let result = try await repository.search(query: "test", page: 1)

        #expect(result == expectedMedia)
        #expect(mockRemoteDataSource.searchCallCount == 1)
    }

    @Test("search passes correct query and page to remote data source")
    func searchPassesCorrectQueryAndPageToRemoteDataSource() async throws {
        mockRemoteDataSource.searchStub = .success([])

        let repository = makeRepository()

        _ = try await repository.search(query: "inception", page: 3)

        #expect(mockRemoteDataSource.searchCalledWith[0].query == "inception")
        #expect(mockRemoteDataSource.searchCalledWith[0].page == 3)
    }

    @Test("search throws unauthorised error when remote throws unauthorised")
    func searchThrowsUnauthorisedWhenRemoteThrowsUnauthorised() async {
        mockRemoteDataSource.searchStub = .failure(.unauthorised)

        let repository = makeRepository()

        await #expect(
            performing: {
                try await repository.search(query: "test", page: 1)
            },
            throws: { error in
                guard let repoError = error as? MediaRepositoryError else {
                    return false
                }
                if case .unauthorised = repoError {
                    return true
                }
                return false
            }
        )
    }

    @Test("search throws unknown error when remote throws unknown")
    func searchThrowsUnknownWhenRemoteThrowsUnknown() async {
        let underlyingError = NSError(domain: "test", code: 123)
        mockRemoteDataSource.searchStub = .failure(.unknown(underlyingError))

        let repository = makeRepository()

        await #expect(
            performing: {
                try await repository.search(query: "test", page: 1)
            },
            throws: { error in
                guard let repoError = error as? MediaRepositoryError else {
                    return false
                }
                if case .unknown = repoError {
                    return true
                }
                return false
            }
        )
    }

    // MARK: - mediaSearchHistory() Tests

    @Test("mediaSearchHistory returns entries from local data source")
    func mediaSearchHistoryReturnsEntriesFromLocalDataSource() async throws {
        let expectedEntries: [MediaSearchHistoryEntry] = [
            .movie(MovieSearchHistoryEntry.mock()),
            .tvSeries(TVSeriesSearchHistoryEntry.mock())
        ]
        mockLocalDataSource.mediaSearchHistoryStub = .success(expectedEntries)

        let repository = makeRepository()

        let result = try await repository.mediaSearchHistory()

        #expect(result.count == expectedEntries.count)
        #expect(mockLocalDataSource.mediaSearchHistoryCallCount == 1)
    }

    @Test("mediaSearchHistory throws unknown error when local throws persistence error")
    func mediaSearchHistoryThrowsUnknownWhenLocalThrowsPersistenceError() async {
        let underlyingError = NSError(domain: "test", code: 456)
        mockLocalDataSource.mediaSearchHistoryStub = .failure(.persistence(underlyingError))

        let repository = makeRepository()

        await #expect(
            performing: {
                try await repository.mediaSearchHistory()
            },
            throws: { error in
                guard let repoError = error as? MediaRepositoryError else {
                    return false
                }
                if case .unknown = repoError {
                    return true
                }
                return false
            }
        )
    }

    // MARK: - saveMovieSearchHistoryEntry() Tests

    @Test("saveMovieSearchHistoryEntry saves entry to local data source")
    func saveMovieSearchHistoryEntrySavesEntryToLocalDataSource() async throws {
        mockLocalDataSource.saveMovieSearchHistoryEntryStub = .success(())
        let entry = MovieSearchHistoryEntry.mock(id: 123)

        let repository = makeRepository()

        try await repository.saveMovieSearchHistoryEntry(entry)

        #expect(mockLocalDataSource.saveMovieSearchHistoryEntryCallCount == 1)
        #expect(mockLocalDataSource.saveMovieSearchHistoryEntryCalledWith[0].id == 123)
    }

    @Test("saveMovieSearchHistoryEntry throws unknown error when local fails")
    func saveMovieSearchHistoryEntryThrowsUnknownWhenLocalFails() async {
        let underlyingError = NSError(domain: "test", code: 789)
        mockLocalDataSource.saveMovieSearchHistoryEntryStub = .failure(.persistence(underlyingError))
        let entry = MovieSearchHistoryEntry.mock()

        let repository = makeRepository()

        await #expect(
            performing: {
                try await repository.saveMovieSearchHistoryEntry(entry)
            },
            throws: { error in
                guard let repoError = error as? MediaRepositoryError else {
                    return false
                }
                if case .unknown = repoError {
                    return true
                }
                return false
            }
        )
    }

    // MARK: - saveTVSeriesSearchHistoryEntry() Tests

    @Test("saveTVSeriesSearchHistoryEntry saves entry to local data source")
    func saveTVSeriesSearchHistoryEntrySavesEntryToLocalDataSource() async throws {
        mockLocalDataSource.saveTVSeriesSearchHistoryEntryStub = .success(())
        let entry = TVSeriesSearchHistoryEntry.mock(id: 456)

        let repository = makeRepository()

        try await repository.saveTVSeriesSearchHistoryEntry(entry)

        #expect(mockLocalDataSource.saveTVSeriesSearchHistoryEntryCallCount == 1)
        #expect(mockLocalDataSource.saveTVSeriesSearchHistoryEntryCalledWith[0].id == 456)
    }

    // MARK: - savePersonSearchHistoryEntry() Tests

    @Test("savePersonSearchHistoryEntry saves entry to local data source")
    func savePersonSearchHistoryEntrySavesEntryToLocalDataSource() async throws {
        mockLocalDataSource.savePersonSearchHistoryEntryStub = .success(())
        let entry = PersonSearchHistoryEntry.mock(id: 789)

        let repository = makeRepository()

        try await repository.savePersonSearchHistoryEntry(entry)

        #expect(mockLocalDataSource.savePersonSearchHistoryEntryCallCount == 1)
        #expect(mockLocalDataSource.savePersonSearchHistoryEntryCalledWith[0].id == 789)
    }

    // MARK: - Helpers

    private func makeRepository() -> DefaultMediaRepository {
        DefaultMediaRepository(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource
        )
    }

}
