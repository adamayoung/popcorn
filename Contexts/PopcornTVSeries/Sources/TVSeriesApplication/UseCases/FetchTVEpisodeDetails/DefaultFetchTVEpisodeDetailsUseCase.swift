//
//  DefaultFetchTVEpisodeDetailsUseCase.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import Observability
import TVSeriesDomain

final class DefaultFetchTVEpisodeDetailsUseCase: FetchTVEpisodeDetailsUseCase {

    private let repository: any TVEpisodeRepository
    private let tvSeasonRepository: any TVSeasonRepository
    private let tvSeriesRepository: any TVSeriesRepository
    private let appConfigurationProvider: any AppConfigurationProviding

    init(
        repository: some TVEpisodeRepository,
        tvSeasonRepository: some TVSeasonRepository,
        tvSeriesRepository: some TVSeriesRepository,
        appConfigurationProvider: some AppConfigurationProviding
    ) {
        self.repository = repository
        self.tvSeasonRepository = tvSeasonRepository
        self.tvSeriesRepository = tvSeriesRepository
        self.appConfigurationProvider = appConfigurationProvider
    }

    func execute(
        tvSeriesID: Int,
        seasonNumber: Int,
        episodeNumber: Int
    ) async throws(FetchTVEpisodeDetailsError) -> TVEpisodeDetails {
        let span = SpanContext.startChild(
            operation: .useCaseExecute,
            description: "FetchTVEpisodeDetailsUseCase.execute"
        )
        span?.setData([
            "tv_series_id": tvSeriesID,
            "season_number": seasonNumber,
            "episode_number": episodeNumber
        ])

        let episode: TVEpisode
        let season: TVSeason
        let series: TVSeries
        let appConfiguration: AppConfiguration
        do {
            async let episodeTask = repository.episode(
                episodeNumber,
                inSeason: seasonNumber,
                inTVSeries: tvSeriesID
            )
            async let seasonTask = tvSeasonRepository.season(
                seasonNumber,
                inTVSeries: tvSeriesID
            )
            async let seriesTask = tvSeriesRepository.tvSeries(withID: tvSeriesID)

            async let configTask = appConfigurationProvider.appConfiguration()
            (episode, season, series, appConfiguration) = try await (episodeTask, seasonTask, seriesTask, configTask)
        } catch let error {
            let detailsError = FetchTVEpisodeDetailsError(error)
            span?.setData(error: detailsError)
            span?.finish(status: .internalError)
            throw detailsError
        }

        let mapper = TVEpisodeDetailsMapper()
        let details = mapper.map(
            episode,
            season: season,
            series: series,
            imagesConfiguration: appConfiguration.images
        )

        span?.finish()
        return details
    }

}
