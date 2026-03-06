//
//  DefaultFetchTrendingTVSeriesUseCase.swift
//  PopcornTrending
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import TrendingDomain

final class DefaultFetchTrendingTVSeriesUseCase: FetchTrendingTVSeriesUseCase {

    private let repository: any TrendingRepository
    private let appConfigurationProvider: any AppConfigurationProviding
    private let themeColorProvider: (any ThemeColorProviding)?

    init(
        repository: some TrendingRepository,
        appConfigurationProvider: some AppConfigurationProviding,
        themeColorProvider: (any ThemeColorProviding)? = nil
    ) {
        self.repository = repository
        self.appConfigurationProvider = appConfigurationProvider
        self.themeColorProvider = themeColorProvider
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

        let themeColors = await extractThemeColors(
            for: tvSeriesPreviews,
            imagesConfiguration: appConfiguration.images
        )

        let mapper = TVSeriesPreviewDetailsMapper()
        return tvSeriesPreviews.map {
            mapper.map(
                $0,
                imagesConfiguration: appConfiguration.images,
                themeColor: themeColors[$0.id]
            )
        }
    }

}

extension DefaultFetchTrendingTVSeriesUseCase {

    private func extractThemeColors(
        for tvSeriesPreviews: [TVSeriesPreview],
        imagesConfiguration: ImagesConfiguration
    ) async -> [Int: ThemeColor] {
        guard let themeColorProvider else {
            return [:]
        }

        var results: [Int: ThemeColor] = [:]

        for tvSeriesPreview in tvSeriesPreviews {
            guard let thumbnailURL = imagesConfiguration.posterURLSet(for: tvSeriesPreview.posterPath)?.thumbnail
            else {
                continue
            }
            if let themeColor = await themeColorProvider.themeColor(for: thumbnailURL) {
                results[tvSeriesPreview.id] = themeColor
            }
        }

        return results
    }

}
