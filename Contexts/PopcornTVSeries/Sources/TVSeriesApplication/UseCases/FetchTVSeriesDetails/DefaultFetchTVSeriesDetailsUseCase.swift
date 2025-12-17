//
//  DefaultFetchTVSeriesDetailsUseCase.swift
//  PopcornTVSeries
//
//  Created by Adam Young on 03/06/2025.
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
        let tvSeriesDetails: TVSeriesDetails
        do {
            tvSeriesDetails = try await SpanContext.trace(
                operation: "usecase.execute",
                description: "FetchTVSeriesDetailsUseCase.execute"
            ) { span in
                span?.setData(key: "tv_series_id", value: id)

                let (tvSeries, imageCollection, appConfiguration) = try await (
                    repository.tvSeries(withID: id),
                    repository.images(forTVSeries: id),
                    appConfigurationProvider.appConfiguration()
                )

                let mapper = TVSeriesDetailsMapper()
                return mapper.map(
                    tvSeries,
                    imageCollection: imageCollection,
                    imagesConfiguration: appConfiguration.images
                )
            }
        } catch {
            throw FetchTVSeriesDetailsError(error)
        }

        return tvSeriesDetails
    }

}
