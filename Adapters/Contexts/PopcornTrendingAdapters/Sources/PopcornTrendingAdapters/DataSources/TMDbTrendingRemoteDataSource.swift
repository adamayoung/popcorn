//
//  TMDbTrendingRemoteDataSource.swift
//  PopcornTrendingAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import TMDb
import TrendingDomain
import TrendingInfrastructure

///
/// A remote data source for fetching trending content from TMDb.
///
/// This class implements ``TrendingRemoteDataSource`` by leveraging the TMDb trending API
/// to retrieve movies, TV series, and people that are trending.
///
final class TMDbTrendingRemoteDataSource: TrendingRemoteDataSource {

    private let trendingService: any TrendingService

    ///
    /// Creates a new TMDb trending remote data source.
    ///
    /// - Parameter trendingService: The TMDb service for fetching trending content.
    ///
    init(trendingService: some TrendingService) {
        self.trendingService = trendingService
    }

    ///
    /// Fetches trending movies from TMDb.
    ///
    /// - Parameter page: The page number for paginated results.
    ///
    /// - Returns: An array of movie previews for trending movies.
    ///
    /// - Throws: ``TrendingRepositoryError`` if the fetch operation fails.
    ///
    func movies(page: Int) async throws(TrendingRepositoryError) -> [MoviePreview] {
        let tmdbMovies: [MovieListItem]
        do {
            tmdbMovies = try await trendingService.movies(
                inTimeWindow: .day,
                page: page,
                language: "en"
            ).results
        } catch let error {
            throw TrendingRepositoryError(error)
        }

        let mapper = MoviePreviewMapper()
        return tmdbMovies.map(mapper.map)
    }

    ///
    /// Fetches trending TV series from TMDb.
    ///
    /// - Parameter page: The page number for paginated results.
    ///
    /// - Returns: An array of TV series previews for trending TV series.
    ///
    /// - Throws: ``TrendingRepositoryError`` if the fetch operation fails.
    ///
    func tvSeries(
        page: Int
    ) async throws(TrendingRepositoryError) -> [TVSeriesPreview] {
        let tmdbTVSeries: [TVSeriesListItem]
        do {
            tmdbTVSeries = try await trendingService.tvSeries(
                inTimeWindow: .day,
                page: page,
                language: "en"
            ).results
        } catch let error {
            throw TrendingRepositoryError(error)
        }

        let mapper = TVSeriesPreviewMapper()
        return tmdbTVSeries.map(mapper.map)
    }

    ///
    /// Fetches trending people from TMDb.
    ///
    /// - Parameter page: The page number for paginated results.
    ///
    /// - Returns: An array of person previews for trending people.
    ///
    /// - Throws: ``TrendingRepositoryError`` if the fetch operation fails.
    ///
    func people(
        page: Int
    ) async throws(TrendingRepositoryError) -> [PersonPreview] {
        let tmdbPeople: [PersonListItem]
        do {
            tmdbPeople = try await trendingService.people(
                inTimeWindow: .day,
                page: page,
                language: "en"
            ).results
        } catch let error {
            throw TrendingRepositoryError(error)
        }

        let mapper = PersonPreviewMapper()
        return tmdbPeople.map(mapper.map)
    }

}

private extension TrendingRepositoryError {

    init(_ error: Error) {
        guard let error = error as? TMDbError else {
            self = .unknown(error)
            return
        }

        self.init(error)
    }

    init(_ error: TMDbError) {
        switch error {
        case .unauthorised:
            self = .unauthorised
        default:
            self = .unknown(error)
        }
    }

}
