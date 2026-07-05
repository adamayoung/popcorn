//
//  ExploreDependencies.swift
//  ExploreFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation

/// The dependencies required by ``ExploreViewModel``.
///
/// A plain `Sendable` struct of closures providing the data dependencies for
/// ``ExploreViewModel``. Constructing it requires every closure, so a missing
/// dependency is a compile error. The production instance is built by the app's
/// composition layer; use ``preview`` for previews and tests.
public struct ExploreDependencies: Sendable {

    public var fetchDiscoverMovies: @Sendable () async throws -> [MoviePreview]
    public var fetchTrendingMovies: @Sendable () async throws -> [MoviePreview]
    public var fetchPopularMovies: @Sendable () async throws -> [MoviePreview]
    public var fetchTrendingTVSeries: @Sendable () async throws -> [TVSeriesPreview]
    public var fetchTrendingPeople: @Sendable () async throws -> [PersonPreview]

    public var isDiscoverMoviesEnabled: @Sendable () throws -> Bool
    public var isTrendingMoviesEnabled: @Sendable () throws -> Bool
    public var isPopularMoviesEnabled: @Sendable () throws -> Bool
    public var isTrendingTVSeriesEnabled: @Sendable () throws -> Bool
    public var isTrendingPeopleEnabled: @Sendable () throws -> Bool

    public init(
        fetchDiscoverMovies: @escaping @Sendable () async throws -> [MoviePreview],
        fetchTrendingMovies: @escaping @Sendable () async throws -> [MoviePreview],
        fetchPopularMovies: @escaping @Sendable () async throws -> [MoviePreview],
        fetchTrendingTVSeries: @escaping @Sendable () async throws -> [TVSeriesPreview],
        fetchTrendingPeople: @escaping @Sendable () async throws -> [PersonPreview],
        isDiscoverMoviesEnabled: @escaping @Sendable () throws -> Bool,
        isTrendingMoviesEnabled: @escaping @Sendable () throws -> Bool,
        isPopularMoviesEnabled: @escaping @Sendable () throws -> Bool,
        isTrendingTVSeriesEnabled: @escaping @Sendable () throws -> Bool,
        isTrendingPeopleEnabled: @escaping @Sendable () throws -> Bool
    ) {
        self.fetchDiscoverMovies = fetchDiscoverMovies
        self.fetchTrendingMovies = fetchTrendingMovies
        self.fetchPopularMovies = fetchPopularMovies
        self.fetchTrendingTVSeries = fetchTrendingTVSeries
        self.fetchTrendingPeople = fetchTrendingPeople
        self.isDiscoverMoviesEnabled = isDiscoverMoviesEnabled
        self.isTrendingMoviesEnabled = isTrendingMoviesEnabled
        self.isPopularMoviesEnabled = isPopularMoviesEnabled
        self.isTrendingTVSeriesEnabled = isTrendingTVSeriesEnabled
        self.isTrendingPeopleEnabled = isTrendingPeopleEnabled
    }

}

#if DEBUG
    public extension ExploreDependencies {

        /// Mock dependencies for previews and snapshot tests.
        static var preview: ExploreDependencies {
            ExploreDependencies(
                fetchDiscoverMovies: {
                    MoviePreview.mocks
                },
                fetchTrendingMovies: {
                    MoviePreview.mocks
                },
                fetchPopularMovies: {
                    MoviePreview.mocks
                },
                fetchTrendingTVSeries: {
                    TVSeriesPreview.mocks
                },
                fetchTrendingPeople: {
                    PersonPreview.mocks
                },
                isDiscoverMoviesEnabled: {
                    true
                },
                isTrendingMoviesEnabled: {
                    true
                },
                isPopularMoviesEnabled: {
                    true
                },
                isTrendingTVSeriesEnabled: {
                    true
                },
                isTrendingPeopleEnabled: {
                    true
                }
            )
        }

    }
#endif
