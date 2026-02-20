//
//  DefaultFetchTVSeasonDetailsUseCase.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import Observability
import TVSeriesDomain

final class DefaultFetchTVSeasonDetailsUseCase: FetchTVSeasonDetailsUseCase {

    private let repository: any TVSeasonRepository
    private let appConfigurationProvider: any AppConfigurationProviding

    init(
        repository: some TVSeasonRepository,
        appConfigurationProvider: some AppConfigurationProviding
    ) {
        self.repository = repository
        self.appConfigurationProvider = appConfigurationProvider
    }

    func execute(
        tvSeriesID: Int,
        seasonNumber: Int
    ) async throws(FetchTVSeasonDetailsError) -> TVSeasonDetailsSummary {
        let span = SpanContext.startChild(
            operation: .useCaseExecute,
            description: "FetchTVSeasonDetailsUseCase.execute"
        )
        span?.setData([
            "tv_series_id": tvSeriesID,
            "season_number": seasonNumber
        ])

        let season: TVSeason
        let appConfiguration: AppConfiguration
        do {
            async let seasonResult = repository.season(seasonNumber, inTVSeries: tvSeriesID)
            async let configResult = appConfigurationProvider.appConfiguration()
            (season, appConfiguration) = try await (seasonResult, configResult)
        } catch let error {
            let detailsError = FetchTVSeasonDetailsError(error)
            span?.setData(error: detailsError)
            span?.finish(status: .internalError)
            throw detailsError
        }

        let mapper = TVEpisodeSummaryMapper()
        let episodes = season.episodes.map {
            mapper.map($0, imagesConfiguration: appConfiguration.images)
        }

        let summary = TVSeasonDetailsSummary(
            overview: season.overview,
            episodes: episodes
        )

        span?.finish()
        return summary
    }

}
