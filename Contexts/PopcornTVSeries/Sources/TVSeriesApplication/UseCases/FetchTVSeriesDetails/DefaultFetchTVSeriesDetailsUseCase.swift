//
//  DefaultFetchTVSeriesDetailsUseCase.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
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

        let tvSeriesDetails: TVSeriesDetails
        do {
            // The theme colour is deliberately not extracted here — it is delivered after
            // first paint by the TV series details stream, keeping the fetch off the
            // poster-thumbnail-download critical path (see ADR-0006, superseding ADR-0002).
            async let tvSeriesTask = repository.tvSeries(withID: id)
            async let imageCollectionTask = repository.images(forTVSeries: id)
            async let appConfigurationTask = appConfigurationProvider.appConfiguration()

            let (tvSeries, imageCollection, appConfiguration) = try await (
                tvSeriesTask, imageCollectionTask, appConfigurationTask
            )

            let mapper = TVSeriesDetailsMapper()
            tvSeriesDetails = mapper.map(
                tvSeries,
                imageCollection: imageCollection,
                imagesConfiguration: appConfiguration.images
            )
        } catch let error {
            let detailsError = FetchTVSeriesDetailsError(error)
            span?.setData(error: detailsError)
            span?.finish(status: .internalError)
            throw detailsError
        }

        span?.finish()
        return tvSeriesDetails
    }

}
