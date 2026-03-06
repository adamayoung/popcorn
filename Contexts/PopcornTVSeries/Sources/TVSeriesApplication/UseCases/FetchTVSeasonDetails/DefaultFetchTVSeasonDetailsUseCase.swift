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
    private let tvSeriesRepository: any TVSeriesRepository
    private let appConfigurationProvider: any AppConfigurationProviding

    init(
        repository: some TVSeasonRepository,
        tvSeriesRepository: some TVSeriesRepository,
        appConfigurationProvider: some AppConfigurationProviding
    ) {
        self.repository = repository
        self.tvSeriesRepository = tvSeriesRepository
        self.appConfigurationProvider = appConfigurationProvider
    }

    func execute(
        tvSeriesID: Int,
        seasonNumber: Int
    ) async throws(FetchTVSeasonDetailsError) -> TVSeasonDetails {
        let span = SpanContext.startChild(
            operation: .useCaseExecute,
            description: "FetchTVSeasonDetailsUseCase.execute"
        )
        span?.setData([
            "tv_series_id": tvSeriesID,
            "season_number": seasonNumber
        ])

        let season: TVSeason
        let tvSeries: TVSeries
        let appConfiguration: AppConfiguration
        do {
            async let seasonResult = repository.season(seasonNumber, inTVSeries: tvSeriesID)
            async let tvSeriesResult = tvSeriesRepository.tvSeries(withID: tvSeriesID)
            async let configResult = appConfigurationProvider.appConfiguration()
            (season, tvSeries, appConfiguration) = try await (seasonResult, tvSeriesResult, configResult)
        } catch let error {
            let detailsError = FetchTVSeasonDetailsError(error)
            span?.setData(error: detailsError)
            span?.finish(status: .internalError)
            throw detailsError
        }

        let mapper = TVSeasonDetailsMapper()
        let tvSeasonDetails = mapper.map(
            season,
            tvSeries: tvSeries,
            imagesConfiguration: appConfiguration.images
        )

        span?.finish()
        return tvSeasonDetails
    }

}
