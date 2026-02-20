//
//  TMDbTVSeasonRemoteDataSource.swift
//  PopcornTVSeriesAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Observability
import TMDb
import TVSeriesDomain
import TVSeriesInfrastructure

final class TMDbTVSeasonRemoteDataSource: TVSeasonRemoteDataSource {

    private let tvSeasonService: any TVSeasonService

    init(tvSeasonService: any TVSeasonService) {
        self.tvSeasonService = tvSeasonService
    }

    func season(
        _ seasonNumber: Int,
        inTVSeries tvSeriesID: Int
    ) async throws(TVSeasonRemoteDataSourceError) -> TVSeriesDomain.TVSeason {
        let span = SpanContext.startChild(
            operation: .remoteDataSourceGet,
            description: "Get Season S\(seasonNumber) TV#\(tvSeriesID)"
        )
        span?.setData([
            "tv_series_id": tvSeriesID,
            "season_number": seasonNumber
        ])

        let tmdbSpan = SpanContext.startChild(
            operation: .tmdbClient,
            description: "Get Season S\(seasonNumber) TV#\(tvSeriesID)"
        )
        tmdbSpan?.setData([
            "tv_series_id": tvSeriesID,
            "season_number": seasonNumber,
            "language": "en"
        ])

        let tmdbSeason: TMDb.TVSeason
        do {
            tmdbSeason = try await tvSeasonService.details(
                forSeason: seasonNumber,
                inTVSeries: tvSeriesID,
                language: "en"
            )
            tmdbSpan?.finish()
        } catch let error {
            tmdbSpan?.setData(error: error)
            tmdbSpan?.finish(status: .internalError)

            let dataSourceError = TVSeasonRemoteDataSourceError(error)
            span?.setData(error: dataSourceError)
            span?.finish(status: .internalError)
            throw dataSourceError
        }

        let episodeMapper = TVEpisodeMapper()
        let episodes = (tmdbSeason.episodes ?? []).map(episodeMapper.map)

        let season = TVSeriesDomain.TVSeason(
            id: tmdbSeason.id,
            name: tmdbSeason.name,
            seasonNumber: tmdbSeason.seasonNumber,
            overview: tmdbSeason.overview,
            posterPath: tmdbSeason.posterPath,
            episodes: episodes
        )

        span?.finish()
        return season
    }

}

private extension TVSeasonRemoteDataSourceError {

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
