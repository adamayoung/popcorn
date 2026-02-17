//
//  TMDbTVSeriesRemoteDataSource.swift
//  PopcornTVSeriesAdapters
//
//  Copyright © 2026 Adam Young.
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
        let span = SpanContext.startChild(
            operation: .remoteDataSourceGet,
            description: "Get TV Series #\(id)"
        )
        span?.setData(key: "tv_series_id", value: id)

        let tmdbSpan = SpanContext.startChild(
            operation: .tmdbClient,
            description: "Get TV Series #\(id)"
        )
        tmdbSpan?.setData([
            "tv_series_id": id,
            "language": "en"
        ])
        let tmdbTVSeries: TMDb.TVSeries
        do {
            tmdbTVSeries = try await tvSeriesService.details(forTVSeries: id, language: "en")
            tmdbSpan?.finish()
        } catch let error {
            tmdbSpan?.setData(error: error)
            tmdbSpan?.finish(status: .internalError)

            let dataSourceError = TVSeriesRemoteDataSourceError(error)
            span?.setData(error: dataSourceError)
            span?.finish(status: .internalError)
            throw dataSourceError
        }

        let mapper = TVSeriesMapper()
        let tvSeries = mapper.map(tmdbTVSeries)

        span?.finish()
        return tvSeries
    }

    func images(
        forTVSeries tvSeriesID: Int
    ) async throws(TVSeriesRemoteDataSourceError) -> TVSeriesDomain.ImageCollection {
        let span = SpanContext.startChild(
            operation: .remoteDataSourceGet,
            description: "Get TV Series ImageCollection #\(tvSeriesID)"
        )
        span?.setData(key: "tv_series_id", value: tvSeriesID)

        let tmdbSpan = SpanContext.startChild(
            operation: .tmdbClient,
            description: "Get TV Series ImageCollection #\(tvSeriesID)"
        )
        tmdbSpan?.setData([
            "tv_series_id": tvSeriesID,
            "filters_languages": "en"
        ])
        let tmdbImageCollection: TMDb.ImageCollection
        do {
            tmdbImageCollection = try await tvSeriesService.images(
                forTVSeries: tvSeriesID,
                filter: .init(languages: ["en"])
            )
            tmdbSpan?.finish()
        } catch let error {
            tmdbSpan?.setData(error: error)
            tmdbSpan?.finish(status: .internalError)

            let dataSourceError = TVSeriesRemoteDataSourceError(error)
            span?.setData(error: dataSourceError)
            span?.finish(status: .internalError)
            throw dataSourceError
        }

        let mapper = ImageCollectionMapper()
        let imageCollection = mapper.map(tmdbImageCollection)
        span?.finish()

        return imageCollection
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
