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
        let imageCollectionDetails: ImageCollectionDetails
        do {
            imageCollectionDetails = try await SpanContext.trace(
                operation: "usecase.execute",
                description: "FetchTVSeriesDetailsUseCase.execute"
            ) { span in
                let (imageCollection, appConfiguration) = try await (
                    repository.images(forTVSeries: tvSeriesID),
                    appConfigurationProvider.appConfiguration()
                )
                let mapper = ImageCollectionDetailsMapper()
                return mapper.map(
                    imageCollection,
                    imagesConfiguration: appConfiguration.images
                )
            }
        } catch let error {
            throw FetchTVSeriesImageCollectionError(error)
        }

        return imageCollectionDetails
    }

}
