//
//  DefaultMediaRepository.swift
//  PopcornSearch
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import SearchDomain

final class DefaultMediaRepository: MediaRepository {

    private let remoteDataSource: any MediaRemoteDataSource
    private let localDataSource: any MediaLocalDataSource

    init(
        remoteDataSource: some MediaRemoteDataSource,
        localDataSource: some MediaLocalDataSource
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }

    func search(query: String, page: Int) async throws(MediaRepositoryError) -> [MediaPreview] {
        let media: [MediaPreview]
        do {
            media = try await remoteDataSource.search(query: query, page: page)
        } catch let error {
            throw MediaRepositoryError(error)
        }

        return media
    }

    func mediaSearchHistory() async throws(MediaRepositoryError) -> [MediaSearchHistoryEntry] {
        let entries: [MediaSearchHistoryEntry]
        do {
            entries = try await localDataSource.mediaSearchHistory()
        } catch let error {
            throw MediaRepositoryError(error)
        }

        return entries
    }

    func saveMovieSearchHistoryEntry(_ entry: MovieSearchHistoryEntry)
    async throws(MediaRepositoryError) {
        do {
            try await localDataSource.saveMovieSearchHistoryEntry(entry)
        } catch let error {
            throw MediaRepositoryError(error)
        }
    }

    func saveTVSeriesSearchHistoryEntry(_ entry: TVSeriesSearchHistoryEntry)
    async throws(MediaRepositoryError) {
        do {
            try await localDataSource.saveTVSeriesSearchHistoryEntry(entry)
        } catch let error {
            throw MediaRepositoryError(error)
        }
    }

    func savePersonSearchHistoryEntry(_ entry: PersonSearchHistoryEntry)
    async throws(MediaRepositoryError) {
        do {
            try await localDataSource.savePersonSearchHistoryEntry(entry)
        } catch let error {
            throw MediaRepositoryError(error)
        }
    }

}

private extension MediaRepositoryError {

    init(_ error: MediaLocalDataSourceError) {
        switch error {
        case .persistence(let error):
            self = .unknown(error)
        case .unknown(let error):
            self = .unknown(error)
        }
    }

    init(_ error: MediaRemoteDataSourceError) {
        switch error {
        case .unauthorised:
            self = .unauthorised
        case .unknown(let error):
            self = .unknown(error)
        }
    }

}
