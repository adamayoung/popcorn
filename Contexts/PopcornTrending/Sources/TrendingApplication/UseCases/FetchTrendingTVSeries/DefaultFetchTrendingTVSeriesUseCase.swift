//
//  DefaultFetchTrendingTVSeriesUseCase.swift
//  PopcornTrending
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation
import TrendingDomain

final class DefaultFetchTrendingTVSeriesUseCase: FetchTrendingTVSeriesUseCase {

    private let repository: any TrendingRepository
    private let appConfigurationProvider: any AppConfigurationProviding

    init(
        repository: some TrendingRepository,
        appConfigurationProvider: some AppConfigurationProviding
    ) {
        self.repository = repository
        self.appConfigurationProvider = appConfigurationProvider
    }

    func execute() async throws(FetchTrendingTVSeriesError) -> [TVSeriesPreviewDetails] {
        try await execute(page: 1)
    }

    func execute(page: Int) async throws(FetchTrendingTVSeriesError) -> [TVSeriesPreviewDetails] {
        let tvSeriesPreviews: [TVSeriesPreview]
        let appConfiguration: AppConfiguration
        do {
            (tvSeriesPreviews, appConfiguration) = try await (
                repository.tvSeries(page: page),
                appConfigurationProvider.appConfiguration()
            )
        } catch let error {
            throw FetchTrendingTVSeriesError(error)
        }

        let mapper = TVSeriesPreviewDetailsMapper()
        return tvSeriesPreviews.map {
            mapper.map($0, imagesConfiguration: appConfiguration.images)
        }
    }

}
