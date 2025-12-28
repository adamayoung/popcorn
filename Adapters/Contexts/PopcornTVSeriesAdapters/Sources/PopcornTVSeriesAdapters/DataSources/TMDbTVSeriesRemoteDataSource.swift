//
//  TMDbTVSeriesRemoteDataSource.swift
//  PopcornTVSeriesAdapters
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation
import TMDb
import TVSeriesDomain
import TVSeriesInfrastructure

///
/// A remote data source for fetching TV series data from TMDb.
///
/// This class implements ``TVSeriesRemoteDataSource`` by leveraging the TMDb API
/// to retrieve detailed TV series information and images.
///
final class TMDbTVSeriesRemoteDataSource: TVSeriesRemoteDataSource {

    private let tvSeriesService: any TVSeriesService

    ///
    /// Creates a new TMDb TV series remote data source.
    ///
    /// - Parameter tvSeriesService: The TMDb service for fetching TV series data.
    ///
    init(tvSeriesService: any TVSeriesService) {
        self.tvSeriesService = tvSeriesService
    }

    ///
    /// Fetches TV series details from TMDb.
    ///
    /// - Parameter id: The unique identifier of the TV series to fetch.
    ///
    /// - Returns: The TV series domain object with full details.
    ///
    /// - Throws: ``TVSeriesRemoteDataSourceError`` if the fetch operation fails.
    ///
    func tvSeries(
        withID id: Int
    ) async throws(TVSeriesRemoteDataSourceError) -> TVSeriesDomain.TVSeries {
        let tmdbTVSeries: TMDb.TVSeries
        do {
            tmdbTVSeries = try await tvSeriesService.details(forTVSeries: id, language: "en")
        } catch let error {
            throw TVSeriesRemoteDataSourceError(error)
        }

        let mapper = TVSeriesMapper()
        return mapper.map(tmdbTVSeries)
    }

    ///
    /// Fetches images for a TV series from TMDb.
    ///
    /// - Parameter tvSeriesID: The unique identifier of the TV series.
    ///
    /// - Returns: An image collection containing posters, backdrops, and logos.
    ///
    /// - Throws: ``TVSeriesRemoteDataSourceError`` if the fetch operation fails.
    ///
    func images(
        forTVSeries tvSeriesID: Int
    ) async throws(TVSeriesRemoteDataSourceError) -> TVSeriesDomain.ImageCollection {
        let tmdbImageCollection: TMDb.ImageCollection
        do {
            tmdbImageCollection = try await tvSeriesService.images(
                forTVSeries: tvSeriesID,
                filter: .init(languages: ["en"])
            )
        } catch let error {
            throw TVSeriesRemoteDataSourceError(error)
        }

        let mapper = ImageCollectionMapper()
        return mapper.map(tmdbImageCollection)
    }

}

private extension TVSeriesRemoteDataSourceError {

    init(_ error: Error) {
        guard let error = error as? TMDbError else {
            self = .unknown(error)
            return
        }

        self.init(error)
    }

    init(_ error: TMDbError) {
        switch error {
        case .notFound:
            self = .notFound
        case .unauthorised:
            self = .unauthorised
        default:
            self = .unknown(error)
        }
    }

}
