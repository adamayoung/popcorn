//
//  DefaultFetchTVSeriesDetailsUseCase.swift
//  PopcornTV
//
//  Created by Adam Young on 03/06/2025.
//

import CoreDomain
import Foundation
import TVDomain

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

    func execute(id: Int) async throws(FetchTVSeriesDetailsError) -> TVSeriesDetails {
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
            throw FetchTVSeriesDetailsError(error)
        }

        let mapper = TVSeriesDetailsMapper()
        let tvSeriesDetails = mapper.map(
            tvSeries,
            imageCollection: imageCollection,
            imagesConfiguration: appConfiguration.images
        )

        return tvSeriesDetails
    }

}
