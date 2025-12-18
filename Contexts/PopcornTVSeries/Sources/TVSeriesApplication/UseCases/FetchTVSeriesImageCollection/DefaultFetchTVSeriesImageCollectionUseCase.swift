//
//  DefaultFetchTVSeriesImageCollectionUseCase.swift
//  PopcornTVSeries
//
//  Created by Adam Young on 24/11/2025.
//

import CoreDomain
import Foundation
import Observability
import TVSeriesDomain

final class DefaultFetchTVSeriesImageCollectionUseCase: FetchTVSeriesImageCollectionUseCase {

    private let repository: any TVSeriesRepository
    private let appConfigurationProvider: any AppConfigurationProviding

    init(
        repository: some TVSeriesRepository,
        appConfigurationProvider: some AppConfigurationProviding
    ) {
        self.repository = repository
        self.appConfigurationProvider = appConfigurationProvider
    }

    func execute(
        tvSeriesID: TVSeries.ID
    ) async throws(FetchTVSeriesImageCollectionError) -> ImageCollectionDetails {
        let span = SpanContext.startChild(
            operation: .useCaseExecute,
            description: "FetchTVSeriesImageCollectionUseCase.execute"
        )

        let imageCollection: ImageCollection
        let appConfiguration: AppConfiguration
        do {
            (imageCollection, appConfiguration) = try await (
                repository.images(forTVSeries: tvSeriesID),
                appConfigurationProvider.appConfiguration()
            )
        } catch let error {
            let e = FetchTVSeriesImageCollectionError(error)
            span?.setData(error: e)
            span?.finish(status: .internalError)
            throw e
        }

        let mapper = ImageCollectionDetailsMapper()
        let imageCollectionDetails = mapper.map(
            imageCollection,
            imagesConfiguration: appConfiguration.images
        )
        span?.finish()

        return imageCollectionDetails
    }

}
