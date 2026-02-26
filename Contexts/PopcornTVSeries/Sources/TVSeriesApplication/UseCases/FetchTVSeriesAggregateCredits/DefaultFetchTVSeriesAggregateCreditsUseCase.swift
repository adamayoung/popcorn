//
//  DefaultFetchTVSeriesAggregateCreditsUseCase.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import TVSeriesDomain

final class DefaultFetchTVSeriesAggregateCreditsUseCase: FetchTVSeriesAggregateCreditsUseCase {

    private let tvSeriesCreditsRepository: any TVSeriesCreditsRepository
    private let appConfigurationProvider: any AppConfigurationProviding

    init(
        tvSeriesCreditsRepository: some TVSeriesCreditsRepository,
        appConfigurationProvider: some AppConfigurationProviding
    ) {
        self.tvSeriesCreditsRepository = tvSeriesCreditsRepository
        self.appConfigurationProvider = appConfigurationProvider
    }

    func execute(
        tvSeriesID: TVSeries.ID
    ) async throws(FetchTVSeriesAggregateCreditsError) -> AggregateCreditsDetails {
        let aggregateCredits: AggregateCredits
        let appConfiguration: AppConfiguration
        do {
            async let creditsTask = tvSeriesCreditsRepository.aggregateCredits(
                forTVSeries: tvSeriesID
            )
            async let appConfigurationTask = appConfigurationProvider.appConfiguration()
            (aggregateCredits, appConfiguration) = try await (creditsTask, appConfigurationTask)
        } catch let error {
            throw FetchTVSeriesAggregateCreditsError(error)
        }

        let mapper = AggregateCreditsDetailsMapper()
        return mapper.map(aggregateCredits, imagesConfiguration: appConfiguration.images)
    }

}
