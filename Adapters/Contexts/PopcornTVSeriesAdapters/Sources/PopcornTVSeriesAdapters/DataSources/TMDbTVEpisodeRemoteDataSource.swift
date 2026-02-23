//
//  TMDbTVEpisodeRemoteDataSource.swift
//  PopcornTVSeriesAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Observability
import TMDb
import TVSeriesDomain
import TVSeriesInfrastructure

final class TMDbTVEpisodeRemoteDataSource: TVEpisodeRemoteDataSource {

    private let tvEpisodeService: any TVEpisodeService

    init(tvEpisodeService: any TVEpisodeService) {
        self.tvEpisodeService = tvEpisodeService
    }

    func episode(
        _ episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: Int
    ) async throws(TVEpisodeRemoteDataSourceError) -> TVSeriesDomain.TVEpisode {
        let span = SpanContext.startChild(
            operation: .remoteDataSourceGet,
            description: "Get Episode S\(seasonNumber)E\(episodeNumber) TV#\(tvSeriesID)"
        )
        span?.setData([
            "tv_series_id": tvSeriesID,
            "season_number": seasonNumber,
            "episode_number": episodeNumber
        ])

        let tmdbSpan = SpanContext.startChild(
            operation: .tmdbClient,
            description: "Get Episode S\(seasonNumber)E\(episodeNumber) TV#\(tvSeriesID)"
        )
        tmdbSpan?.setData([
            "tv_series_id": tvSeriesID,
            "season_number": seasonNumber,
            "episode_number": episodeNumber,
            "language": "en"
        ])

        let tmdbEpisode: TMDb.TVEpisode
        do {
            tmdbEpisode = try await tvEpisodeService.details(
                forEpisode: episodeNumber,
                inSeason: seasonNumber,
                inTVSeries: tvSeriesID,
                language: "en"
            )
            tmdbSpan?.finish()
        } catch let error {
            tmdbSpan?.setData(error: error)
            tmdbSpan?.finish(status: .internalError)

            let dataSourceError = TVEpisodeRemoteDataSourceError(error)
            span?.setData(error: dataSourceError)
            span?.finish(status: .internalError)
            throw dataSourceError
        }

        let mapper = TVEpisodeMapper()
        let episode = mapper.map(tmdbEpisode)

        span?.finish()
        return episode
    }

}

private extension TVEpisodeRemoteDataSourceError {

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
