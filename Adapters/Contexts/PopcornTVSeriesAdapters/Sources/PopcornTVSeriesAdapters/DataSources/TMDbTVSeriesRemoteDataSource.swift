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

final class TMDbTVSeriesRemoteDataSource: TVSeriesRemoteDataSource {

    private let tvSeriesService: any TVSeriesService

    init(tvSeriesService: any TVSeriesService) {
        self.tvSeriesService = tvSeriesService
    }

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
