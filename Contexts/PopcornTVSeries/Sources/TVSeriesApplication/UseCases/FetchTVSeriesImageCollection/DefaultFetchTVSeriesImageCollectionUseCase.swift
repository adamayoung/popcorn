//
//  DefaultFetchTVSeriesImageCollectionUseCase.swift
//  PopcornTVSeries
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation
import TVSeriesDomain

// swiftlint:disable:next type_name
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
        let imageCollection: ImageCollection
        let appConfiguration: AppConfiguration
        do {
            (imageCollection, appConfiguration) = try await (
                repository.images(forTVSeries: tvSeriesID),
                appConfigurationProvider.appConfiguration()
            )
        } catch let error {
            throw FetchTVSeriesImageCollectionError(error)
        }

        let mapper = ImageCollectionDetailsMapper()
        let imageCollectionDetails = mapper.map(
            imageCollection,
            imagesConfiguration: appConfiguration.images
        )

        return imageCollectionDetails
    }

}
