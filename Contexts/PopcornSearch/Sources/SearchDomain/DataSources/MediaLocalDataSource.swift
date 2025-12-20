//
//  MediaLocalDataSource.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public protocol MediaLocalDataSource: Sendable {

    func mediaSearchHistory() async throws(MediaLocalDataSourceError) -> [MediaSearchHistoryEntry]

    func movieSearchHistory() async throws(MediaLocalDataSourceError) -> [MovieSearchHistoryEntry]

    func tvSeriesSearchHistory() async throws(MediaLocalDataSourceError)
        -> [TVSeriesSearchHistoryEntry]

    func personSearchHistory() async throws(MediaLocalDataSourceError) -> [PersonSearchHistoryEntry]

    func saveMovieSearchHistoryEntry(_ entry: MovieSearchHistoryEntry)
        async throws(MediaLocalDataSourceError)

    func saveTVSeriesSearchHistoryEntry(_ entry: TVSeriesSearchHistoryEntry)
        async throws(MediaLocalDataSourceError)

    func savePersonSearchHistoryEntry(_ entry: PersonSearchHistoryEntry)
        async throws(MediaLocalDataSourceError)

}

public enum MediaLocalDataSourceError: Error {

    case persistence(Error)
    case unknown(Error? = nil)

}
