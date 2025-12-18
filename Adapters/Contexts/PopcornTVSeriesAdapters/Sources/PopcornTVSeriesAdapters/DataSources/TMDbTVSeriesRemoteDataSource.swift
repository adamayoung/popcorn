//
//  TMDbTVSeriesRemoteDataSource.swift
//  PopcornTVSeriesAdapters
//
//  Created by Adam Young on 18/11/2025.
//

import CoreDomain
import Foundation
import Observability
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
        let httpSpan = SpanContext.startChild(
            operation: "http.client",
            description: "GET /3/tv/\(id)"
        )
        httpSpan?.setData([
            "http.method": "GET",
            "http.url": "/3/tv/\(id)",
            "service": "tmdb",
            "entity_type": "tvSeries",
            "entity_id": id,
            "language": "en"
        ])

        let tmdbTVSeries: TMDb.TVSeries
        do {
            tmdbTVSeries = try await tvSeriesService.details(forTVSeries: id, language: "en")
            httpSpan?.finish()
        } catch let error {
            httpSpan?.finish(status: .internalError)
            throw TVSeriesRemoteDataSourceError(error)
        }

        let mapper = TVSeriesMapper()
        let tvSeries = mapper.map(tmdbTVSeries)

        return tvSeries
    }

    func images(
        forTVSeries tvSeriesID: Int
    ) async throws(TVSeriesRemoteDataSourceError) -> TVSeriesDomain.ImageCollection {
        let httpSpan = SpanContext.startChild(
            operation: "http.client",
            description: "GET /3/tv/\(tvSeriesID)/images"
        )

        let tmdbImageCollection: TMDb.ImageCollection
        do {
            tmdbImageCollection = try await tvSeriesService.images(
                forTVSeries: tvSeriesID,
                filter: .init(languages: ["en"])
            )
            httpSpan?.finish()
        } catch let error {
            httpSpan?.finish(status: .internalError)
            throw TVSeriesRemoteDataSourceError(error)
        }

        let mapper = ImageCollectionMapper()
        let imageCollection = mapper.map(tmdbImageCollection)

        return imageCollection
    }

}

extension TVSeriesRemoteDataSourceError {

    fileprivate init(_ error: Error) {
        guard let error = error as? TMDbError else {
            self = .unknown(error)
            return
        }

        self.init(error)
    }

    fileprivate init(_ error: TMDbError) {
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
