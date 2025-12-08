//
//  MediaSearchClient.swift
//  MediaSearchFeature
//
//  Created by Adam Young on 25/11/2025.
//

import ComposableArchitecture
import Foundation
import SearchApplication
import SearchKitAdapters

struct MediaSearchClient: Sendable {

    var search: @Sendable (String) async throws -> [MediaPreview]
    var fetchMediaSearchHistory: @Sendable () async throws -> [MediaPreview]
    var addMovieSearchHistoryEntry: @Sendable (Int) async throws -> Void
    var addTVSeriesSearchHistoryEntry: @Sendable (Int) async throws -> Void
    var addPersonSearchHistoryEntry: @Sendable (Int) async throws -> Void

}

extension MediaSearchClient: DependencyKey {

    static var liveValue: MediaSearchClient {
        let factory = MediaSearchClientFactory()

        return MediaSearchClient(
            search: { query in
                let useCase = factory.makeSearchMedia()
                let media = try await useCase.execute(query: query)
                let mapper = MediaPreviewMapper()
                return media.map(mapper.map)
            },
            fetchMediaSearchHistory: {
                let useCase = factory.makeFetchMediaSearchHistory()
                let media = try await useCase.execute()
                let mapper = MediaPreviewMapper()
                return media.map(mapper.map)
            },
            addMovieSearchHistoryEntry: { id in
                let useCase = factory.makeAddMediaSearchHistoryEntry()
                try await useCase.execute(movieID: id)
            },
            addTVSeriesSearchHistoryEntry: { id in
                let useCase = factory.makeAddMediaSearchHistoryEntry()
                try await useCase.execute(movieID: id)
            },
            addPersonSearchHistoryEntry: { id in
                let useCase = factory.makeAddMediaSearchHistoryEntry()
                try await useCase.execute(personID: id)
            }
        )
    }

    static var previewValue: MediaSearchClient {
        MediaSearchClient(
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

    var mediaSearch: MediaSearchClient {
        get {
            self[MediaSearchClient.self]
        }
        set {
            self[MediaSearchClient.self] = newValue
        }
    }

}
