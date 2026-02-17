//
//  MockMediaLocalDataSource.swift
//  PopcornSearch
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SearchDomain
import SearchInfrastructure

final class MockMediaLocalDataSource: MediaLocalDataSource, @unchecked Sendable {

    var mediaSearchHistoryCallCount = 0
    var mediaSearchHistoryStub: Result<[MediaSearchHistoryEntry], MediaLocalDataSourceError>?

    func mediaSearchHistory() async throws(MediaLocalDataSourceError) -> [MediaSearchHistoryEntry] {
        mediaSearchHistoryCallCount += 1

        guard let stub = mediaSearchHistoryStub else {
            throw .unknown(nil)
        }

        switch stub {
        case .success(let entries):
            return entries
        case .failure(let error):
            throw error
        }
    }

    var movieSearchHistoryCallCount = 0
    var movieSearchHistoryStub: Result<[MovieSearchHistoryEntry], MediaLocalDataSourceError>?

    func movieSearchHistory() async throws(MediaLocalDataSourceError) -> [MovieSearchHistoryEntry] {
        movieSearchHistoryCallCount += 1

        guard let stub = movieSearchHistoryStub else {
            throw .unknown(nil)
        }

        switch stub {
        case .success(let entries):
            return entries
        case .failure(let error):
            throw error
        }
    }

    var tvSeriesSearchHistoryCallCount = 0
    var tvSeriesSearchHistoryStub: Result<[TVSeriesSearchHistoryEntry], MediaLocalDataSourceError>?

    func tvSeriesSearchHistory() async throws(MediaLocalDataSourceError)
    -> [TVSeriesSearchHistoryEntry] {
        tvSeriesSearchHistoryCallCount += 1

        guard let stub = tvSeriesSearchHistoryStub else {
            throw .unknown(nil)
        }

        switch stub {
        case .success(let entries):
            return entries
        case .failure(let error):
            throw error
        }
    }

    var personSearchHistoryCallCount = 0
    var personSearchHistoryStub: Result<[PersonSearchHistoryEntry], MediaLocalDataSourceError>?

    func personSearchHistory() async throws(MediaLocalDataSourceError) -> [PersonSearchHistoryEntry] {
        personSearchHistoryCallCount += 1

        guard let stub = personSearchHistoryStub else {
            throw .unknown(nil)
        }

        switch stub {
        case .success(let entries):
            return entries
        case .failure(let error):
            throw error
        }
    }

    var saveMovieSearchHistoryEntryCallCount = 0
    var saveMovieSearchHistoryEntryCalledWith: [MovieSearchHistoryEntry] = []
    var saveMovieSearchHistoryEntryStub: Result<Void, MediaLocalDataSourceError>?

    func saveMovieSearchHistoryEntry(_ entry: MovieSearchHistoryEntry)
    async throws(MediaLocalDataSourceError) {
        saveMovieSearchHistoryEntryCallCount += 1
        saveMovieSearchHistoryEntryCalledWith.append(entry)

        if case .failure(let error) = saveMovieSearchHistoryEntryStub {
            throw error
        }
    }

    var saveTVSeriesSearchHistoryEntryCallCount = 0
    var saveTVSeriesSearchHistoryEntryCalledWith: [TVSeriesSearchHistoryEntry] = []
    var saveTVSeriesSearchHistoryEntryStub: Result<Void, MediaLocalDataSourceError>?

    func saveTVSeriesSearchHistoryEntry(_ entry: TVSeriesSearchHistoryEntry)
    async throws(MediaLocalDataSourceError) {
        saveTVSeriesSearchHistoryEntryCallCount += 1
        saveTVSeriesSearchHistoryEntryCalledWith.append(entry)

        if case .failure(let error) = saveTVSeriesSearchHistoryEntryStub {
            throw error
        }
    }

    var savePersonSearchHistoryEntryCallCount = 0
    var savePersonSearchHistoryEntryCalledWith: [PersonSearchHistoryEntry] = []
    var savePersonSearchHistoryEntryStub: Result<Void, MediaLocalDataSourceError>?

    func savePersonSearchHistoryEntry(_ entry: PersonSearchHistoryEntry)
    async throws(MediaLocalDataSourceError) {
        savePersonSearchHistoryEntryCallCount += 1
        savePersonSearchHistoryEntryCalledWith.append(entry)

        if case .failure(let error) = savePersonSearchHistoryEntryStub {
            throw error
        }
    }

}
