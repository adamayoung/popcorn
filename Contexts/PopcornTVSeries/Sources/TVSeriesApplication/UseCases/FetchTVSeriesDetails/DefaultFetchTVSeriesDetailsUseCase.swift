//
//  DefaultFetchTVSeriesDetailsUseCase.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation
import Observability
import TVSeriesDomain

final class DefaultFetchTVSeriesDetailsUseCase: FetchTVSeriesDetailsUseCase {

    private let repository: any TVSeriesRepository
    private let appConfigurationProvider: any AppConfigurationProviding

    init(
        repository: some TVSeriesRepository,
        appConfigurationProvider: some AppConfigurationProviding
    ) {
        self.repository = repository
        self.appConfigurationProvider = appConfigurationProvider
    }

    func execute(id: TVSeries.ID) async throws(FetchTVSeriesDetailsError) -> TVSeriesDetails {
        let span = SpanContext.startChild(
            operation: .useCaseExecute,
            description: "FetchTVSeriesDetailsUseCase.execute"
        )
        span?.setData(key: "tv_series_id", value: id)

        let tvSeries: TVSeries
        let imageCollection: ImageCollection
        let appConfiguration: AppConfiguration
        do {
            (tvSeries, imageCollection, appConfiguration) = try await (
                repository.tvSeries(withID: id),
                repository.images(forTVSeries: id),
                appConfigurationProvider.appConfiguration()
            )
        } catch let error {
            let detailsError = FetchTVSeriesDetailsError(error)
            span?.setData(error: detailsError)
            span?.finish(status: .internalError)
            throw detailsError
        }

        let mapper = TVSeriesDetailsMapper()
        let tvSeriesDetails = mapper.map(
            tvSeries,
            imageCollection: imageCollection,
            imagesConfiguration: appConfiguration.images
        )

        span?.finish()
        return tvSeriesDetails
    }

}
