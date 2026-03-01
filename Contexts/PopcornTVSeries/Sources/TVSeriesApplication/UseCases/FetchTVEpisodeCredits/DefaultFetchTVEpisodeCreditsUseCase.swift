//
//  DefaultFetchTVEpisodeCreditsUseCase.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import TVSeriesDomain

final class DefaultFetchTVEpisodeCreditsUseCase: FetchTVEpisodeCreditsUseCase {

    private let tvEpisodeCreditsRepository: any TVEpisodeCreditsRepository
    private let appConfigurationProvider: any AppConfigurationProviding

    init(
        tvEpisodeCreditsRepository: some TVEpisodeCreditsRepository,
        appConfigurationProvider: some AppConfigurationProviding
    ) {
        self.tvEpisodeCreditsRepository = tvEpisodeCreditsRepository
        self.appConfigurationProvider = appConfigurationProvider
    }

    func execute(
        tvSeriesID: Int,
        seasonNumber: Int,
        episodeNumber: Int
    ) async throws(FetchTVEpisodeCreditsError) -> CreditsDetails {
        let credits: Credits
        let appConfiguration: AppConfiguration
        do {
            async let creditsTask = tvEpisodeCreditsRepository.credits(
                forEpisode: episodeNumber,
                inSeason: seasonNumber,
                inTVSeries: tvSeriesID
            )
            async let appConfigurationTask = appConfigurationProvider.appConfiguration()
            (credits, appConfiguration) = try await (creditsTask, appConfigurationTask)
        } catch let error {
            throw FetchTVEpisodeCreditsError(error)
        }

        let mapper = CreditsDetailsMapper()
        return mapper.map(credits, imagesConfiguration: appConfiguration.images)
    }

}
