//
//  DefaultFetchTVSeriesCreditsUseCase.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import TVSeriesDomain

final class DefaultFetchTVSeriesCreditsUseCase: FetchTVSeriesCreditsUseCase {

    private let tvSeriesCreditsRepository: any TVSeriesCreditsRepository
    private let appConfigurationProvider: any AppConfigurationProviding

    init(
        tvSeriesCreditsRepository: some TVSeriesCreditsRepository,
        appConfigurationProvider: some AppConfigurationProviding
    ) {
        self.tvSeriesCreditsRepository = tvSeriesCreditsRepository
        self.appConfigurationProvider = appConfigurationProvider
    }

    func execute(tvSeriesID: TVSeries.ID) async throws(FetchTVSeriesCreditsError) -> CreditsDetails {
        let credits: Credits
        let appConfiguration: AppConfiguration
        do {
            (credits, appConfiguration) = try await (
                tvSeriesCreditsRepository.credits(forTVSeries: tvSeriesID),
                appConfigurationProvider.appConfiguration()
            )
        } catch let error {
            throw FetchTVSeriesCreditsError(error)
        }

        let mapper = CreditsDetailsMapper()
        return mapper.map(credits, imagesConfiguration: appConfiguration.images)
    }

}
