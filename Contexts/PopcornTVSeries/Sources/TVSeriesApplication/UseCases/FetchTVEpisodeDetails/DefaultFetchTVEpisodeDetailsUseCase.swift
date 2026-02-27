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
    private let appConfigurationProvider: any AppConfigurationProviding

    init(
        repository: some TVEpisodeRepository,
        appConfigurationProvider: some AppConfigurationProviding
    ) {
        self.repository = repository
        self.appConfigurationProvider = appConfigurationProvider
    }

    func execute(
        tvSeriesID: Int,
        seasonNumber: Int,
        episodeNumber: Int
    ) async throws(FetchTVEpisodeDetailsError) -> TVEpisodeSummary {
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
        let appConfiguration: AppConfiguration
        do {
            async let episodeResult = repository.episode(
                episodeNumber,
                inSeason: seasonNumber,
                inTVSeries: tvSeriesID
            )
            async let configResult = appConfigurationProvider.appConfiguration()
            (episode, appConfiguration) = try await (episodeResult, configResult)
        } catch let error {
            let detailsError = FetchTVEpisodeDetailsError(error)
            span?.setData(error: detailsError)
            span?.finish(status: .internalError)
            throw detailsError
        }

        let mapper = TVEpisodeSummaryMapper()
        let summary = mapper.map(episode, imagesConfiguration: appConfiguration.images)

        span?.finish()
        return summary
    }

}
