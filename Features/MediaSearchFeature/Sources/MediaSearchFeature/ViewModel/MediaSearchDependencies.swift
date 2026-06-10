//
//  MediaSearchDependencies.swift
//  MediaSearchFeature
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import Foundation
import GenresApplication
import SearchApplication

/// The dependencies required by ``MediaSearchViewModel``.
///
/// A plain `Sendable` struct of closures providing the data dependencies for
/// ``MediaSearchViewModel``. Constructing it requires every closure, so a missing
/// dependency is a compile error. Build the production instance with ``live(services:)``.
public struct MediaSearchDependencies: Sendable {

    public var fetchGenres: @Sendable () async throws -> [Genre]
    public var search: @Sendable (String) async throws -> [MediaPreview]
    public var fetchMediaSearchHistory: @Sendable () async throws -> [MediaPreview]
    public var addMovieSearchHistoryEntry: @Sendable (Int) async throws -> Void
    public var addTVSeriesSearchHistoryEntry: @Sendable (Int) async throws -> Void
    public var addPersonSearchHistoryEntry: @Sendable (Int) async throws -> Void

    public init(
        fetchGenres: @escaping @Sendable () async throws -> [Genre],
        search: @escaping @Sendable (String) async throws -> [MediaPreview],
        fetchMediaSearchHistory: @escaping @Sendable () async throws -> [MediaPreview],
        addMovieSearchHistoryEntry: @escaping @Sendable (Int) async throws -> Void,
        addTVSeriesSearchHistoryEntry: @escaping @Sendable (Int) async throws -> Void,
        addPersonSearchHistoryEntry: @escaping @Sendable (Int) async throws -> Void
    ) {
        self.fetchGenres = fetchGenres
        self.search = search
        self.fetchMediaSearchHistory = fetchMediaSearchHistory
        self.addMovieSearchHistoryEntry = addMovieSearchHistoryEntry
        self.addTVSeriesSearchHistoryEntry = addTVSeriesSearchHistoryEntry
        self.addPersonSearchHistoryEntry = addPersonSearchHistoryEntry
    }

}

public extension MediaSearchDependencies {

    /// Builds the production dependencies from the app's shared services.
    static func live(services: AppServices) -> MediaSearchDependencies {
        let fetchAllGenres = services.genresFactory.makeFetchAllGenresUseCase()
        let searchMedia = services.searchFactory.makeSearchMediaUseCase()
        let fetchMediaSearchHistory = services.searchFactory.makeFetchMediaSearchHistory()
        let addMediaSearchHistoryEntry = services.searchFactory.makeAddMediaSearchHistoryEntryUseCase()

        return MediaSearchDependencies(
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

}

#if DEBUG
    public extension MediaSearchDependencies {

        /// Mock dependencies for previews and snapshot tests.
        static var preview: MediaSearchDependencies {
            MediaSearchDependencies(
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
#endif
