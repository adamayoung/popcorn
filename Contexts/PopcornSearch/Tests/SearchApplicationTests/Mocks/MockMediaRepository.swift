//
//  MockMediaRepository.swift
//  PopcornSearch
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SearchDomain

final class MockMediaRepository: MediaRepository, @unchecked Sendable {

    var searchCallCount = 0
    var searchCalledWith: [(query: String, page: Int)] = []
    var searchStub: Result<[MediaPreview], MediaRepositoryError>?

    func search(query: String, page: Int) async throws(MediaRepositoryError) -> [MediaPreview] {
        searchCallCount += 1
        searchCalledWith.append((query: query, page: page))

        guard let stub = searchStub else {
            throw .unknown(nil)
        }

        switch stub {
        case .success(let media):
            return media
        case .failure(let error):
            throw error
        }
    }

    var mediaSearchHistoryCallCount = 0
    var mediaSearchHistoryStub: Result<[MediaSearchHistoryEntry], MediaRepositoryError>?

    func mediaSearchHistory() async throws(MediaRepositoryError) -> [MediaSearchHistoryEntry] {
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

    var saveMovieSearchHistoryEntryCallCount = 0
    var saveMovieSearchHistoryEntryCalledWith: [MovieSearchHistoryEntry] = []
    var saveMovieSearchHistoryEntryStub: Result<Void, MediaRepositoryError>?

    func saveMovieSearchHistoryEntry(_ entry: MovieSearchHistoryEntry)
    async throws(MediaRepositoryError) {
        saveMovieSearchHistoryEntryCallCount += 1
        saveMovieSearchHistoryEntryCalledWith.append(entry)

        if case .failure(let error) = saveMovieSearchHistoryEntryStub {
            throw error
        }
    }

    var saveTVSeriesSearchHistoryEntryCallCount = 0
    var saveTVSeriesSearchHistoryEntryCalledWith: [TVSeriesSearchHistoryEntry] = []
    var saveTVSeriesSearchHistoryEntryStub: Result<Void, MediaRepositoryError>?

    func saveTVSeriesSearchHistoryEntry(_ entry: TVSeriesSearchHistoryEntry)
    async throws(MediaRepositoryError) {
        saveTVSeriesSearchHistoryEntryCallCount += 1
        saveTVSeriesSearchHistoryEntryCalledWith.append(entry)

        if case .failure(let error) = saveTVSeriesSearchHistoryEntryStub {
            throw error
        }
    }

    var savePersonSearchHistoryEntryCallCount = 0
    var savePersonSearchHistoryEntryCalledWith: [PersonSearchHistoryEntry] = []
    var savePersonSearchHistoryEntryStub: Result<Void, MediaRepositoryError>?

    func savePersonSearchHistoryEntry(_ entry: PersonSearchHistoryEntry)
    async throws(MediaRepositoryError) {
        savePersonSearchHistoryEntryCallCount += 1
        savePersonSearchHistoryEntryCalledWith.append(entry)

        if case .failure(let error) = savePersonSearchHistoryEntryStub {
            throw error
        }
    }

}
