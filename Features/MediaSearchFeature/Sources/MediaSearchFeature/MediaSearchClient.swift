//
//  MediaSearchClient.swift
//  MediaSearchFeature
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import ComposableArchitecture
import Foundation
import GenresApplication
import SearchApplication

@DependencyClient
struct MediaSearchClient {

    var fetchGenres: @Sendable () async throws -> [Genre]
    var search: @Sendable (String) async throws -> [MediaPreview]
    var fetchMediaSearchHistory: @Sendable () async throws -> [MediaPreview]
    var addMovieSearchHistoryEntry: @Sendable (Int) async throws -> Void
    var addTVSeriesSearchHistoryEntry: @Sendable (Int) async throws -> Void
    var addPersonSearchHistoryEntry: @Sendable (Int) async throws -> Void

}

extension MediaSearchClient: DependencyKey {

    static var liveValue: MediaSearchClient {
        @Dependency(\.fetchAllGenres) var fetchAllGenres
        @Dependency(\.searchMedia) var searchMedia
        @Dependency(\.fetchMediaSearchHistory) var fetchMediaSearchHistory
        @Dependency(\.addMediaSearchHistoryEntry) var addMediaSearchHistoryEntry

        return MediaSearchClient(
            fetchGenres: {
                let genres = try await fetchAllGenres.execute()
                let mapper = GenreMapper()
                return genres.map(mapper.map)
            },
            search: { query in
                let media = try await searchMedia.execute(query: query)
                let mapper = MediaPreviewMapper()
                return media.map(mapper.map)
            },
            fetchMediaSearchHistory: {
                let media = try await fetchMediaSearchHistory.execute()
                let mapper = MediaPreviewMapper()
                return media.map(mapper.map)
            },
            addMovieSearchHistoryEntry: { id in
                try await addMediaSearchHistoryEntry.execute(movieID: id)
            },
            addTVSeriesSearchHistoryEntry: { id in
                try await addMediaSearchHistoryEntry.execute(tvSeriesID: id)
            },
            addPersonSearchHistoryEntry: { id in
                try await addMediaSearchHistoryEntry.execute(personID: id)
            }
        )
    }

    static var previewValue: MediaSearchClient {
        MediaSearchClient(
            fetchGenres: {
                Genre.mocks
            },
            search: { _ in
                try await Task.sleep(for: .seconds(2))
                return MediaPreview.mocks
            },
            fetchMediaSearchHistory: {
                MediaPreview.mocks
            },
            addMovieSearchHistoryEntry: { _ in },
            addTVSeriesSearchHistoryEntry: { _ in },
            addPersonSearchHistoryEntry: { _ in }
        )
    }

}

extension DependencyValues {

    var mediaSearchClient: MediaSearchClient {
        get {
            self[MediaSearchClient.self]
        }
        set {
            self[MediaSearchClient.self] = newValue
        }
    }

}
