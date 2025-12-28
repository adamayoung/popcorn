//
//  TMDbDiscoverRemoteDataSource.swift
//  PopcornDiscoverAdapters
//
//  Copyright © 2025 Adam Young.
//

import DiscoverDomain
import DiscoverInfrastructure
import Foundation
import TMDb

///
/// A remote data source that fetches discoverable movies and TV series from TMDb API.
///
/// This data source adapts the TMDb discover service to the domain's
/// ``DiscoverRemoteDataSource`` protocol, enabling content discovery with
/// optional filtering capabilities.
///
final class TMDbDiscoverRemoteDataSource: DiscoverRemoteDataSource {

    private let discoverService: any DiscoverService

    ///
    /// Creates a new TMDb discover remote data source.
    ///
    /// - Parameter discoverService: The TMDb discover service for fetching content.
    ///
    init(discoverService: some DiscoverService) {
        self.discoverService = discoverService
    }

    ///
    /// Fetches discoverable movies for a specific page.
    ///
    /// - Parameter page: The page number for paginated results (1-indexed).
    ///
    /// - Returns: An array of movie previews for the requested page.
    ///
    /// - Throws: ``DiscoverRemoteDataSourceError`` if the fetch operation fails.
    ///
    func movies(page: Int) async throws(DiscoverRemoteDataSourceError) -> [MoviePreview] {
        try await movies(filter: nil, page: page)
    }

    ///
    /// Fetches discoverable movies with optional filtering.
    ///
    /// - Parameters:
    ///   - filter: Optional filter criteria for narrowing results.
    ///   - page: The page number for paginated results (1-indexed).
    ///
    /// - Returns: An array of movie previews matching the filter criteria.
    ///
    /// - Throws: ``DiscoverRemoteDataSourceError`` if the fetch operation fails.
    ///
    func movies(
        filter: MovieFilter?,
        page: Int
    ) async throws(DiscoverRemoteDataSourceError) -> [MoviePreview] {
        let filterMapper = TMDbDiscoverMovieFilterMapper()
        let tmdbMovies: [MovieListItem]
        do {
            tmdbMovies = try await discoverService.movies(
                filter: filterMapper.compactMap(filter),
                page: page,
                language: "en"
            ).results
        } catch let error {
            throw DiscoverRemoteDataSourceError(error)
        }

        let mapper = MoviePreviewMapper()
        return tmdbMovies.map(mapper.map)
    }

    ///
    /// Fetches discoverable TV series for a specific page.
    ///
    /// - Parameter page: The page number for paginated results (1-indexed).
    ///
    /// - Returns: An array of TV series previews for the requested page.
    ///
    /// - Throws: ``DiscoverRemoteDataSourceError`` if the fetch operation fails.
    ///
    func tvSeries(page: Int) async throws(DiscoverRemoteDataSourceError) -> [TVSeriesPreview] {
        try await tvSeries(filter: nil, page: page)
    }

    ///
    /// Fetches discoverable TV series with optional filtering.
    ///
    /// - Parameters:
    ///   - filter: Optional filter criteria for narrowing results.
    ///   - page: The page number for paginated results (1-indexed).
    ///
    /// - Returns: An array of TV series previews matching the filter criteria.
    ///
    /// - Throws: ``DiscoverRemoteDataSourceError`` if the fetch operation fails.
    ///
    func tvSeries(
        filter: TVSeriesFilter?,
        page: Int
    ) async throws(DiscoverRemoteDataSourceError) -> [TVSeriesPreview] {
        let filterMapper = TMDbDiscoverTVSeriesFilterMapper()
        let tmdbTVSeries: [TVSeriesListItem]
        do {
            tmdbTVSeries = try await discoverService.tvSeries(
                filter: filterMapper.compactMap(filter),
                page: page,
                language: "en"
            ).results
        } catch let error {
            throw DiscoverRemoteDataSourceError(error)
        }

        let mapper = TVSeriesPreviewMapper()
        return tmdbTVSeries.map(mapper.map)
    }

}

private extension DiscoverRemoteDataSourceError {

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
