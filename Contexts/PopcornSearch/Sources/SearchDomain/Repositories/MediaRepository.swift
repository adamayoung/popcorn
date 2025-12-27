//
//  MediaRepository.swift
//  PopcornSearch
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public protocol MediaRepository: Sendable {

    func search(
        query: String,
        page: Int,
        cachePolicy: CachePolicy
    ) async throws(MediaRepositoryError) -> [MediaPreview]

    func mediaSearchHistory(
        cachePolicy: CachePolicy
    ) async throws(MediaRepositoryError) -> [MediaSearchHistoryEntry]

    func saveMovieSearchHistoryEntry(_ entry: MovieSearchHistoryEntry)
        async throws(MediaRepositoryError)

    func saveTVSeriesSearchHistoryEntry(_ entry: TVSeriesSearchHistoryEntry)
        async throws(MediaRepositoryError)

    func savePersonSearchHistoryEntry(_ entry: PersonSearchHistoryEntry)
        async throws(MediaRepositoryError)

}

extension MediaRepository {

    public func search(query: String, page: Int) async throws(MediaRepositoryError) -> [MediaPreview] {
        try await search(query: query, page: page, cachePolicy: .cacheFirst)
    }

    public func mediaSearchHistory() async throws(MediaRepositoryError) -> [MediaSearchHistoryEntry] {
        try await mediaSearchHistory(cachePolicy: .cacheFirst)
    }

}

public enum MediaRepositoryError: Error {

    case cacheUnavailable
    case unauthorised
    case unknown(Error?)

}
