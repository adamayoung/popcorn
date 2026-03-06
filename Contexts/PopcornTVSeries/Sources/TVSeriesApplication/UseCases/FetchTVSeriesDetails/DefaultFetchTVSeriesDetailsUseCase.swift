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
    private let themeColorProvider: (any ThemeColorProviding)?

    init(
        repository: some TVSeriesRepository,
        appConfigurationProvider: some AppConfigurationProviding,
        themeColorProvider: (any ThemeColorProviding)? = nil
    ) {
        self.repository = repository
        self.appConfigurationProvider = appConfigurationProvider
        self.themeColorProvider = themeColorProvider
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

        let themeColor = await extractThemeColor(
            posterPath: tvSeries.posterPath,
            imagesConfiguration: appConfiguration.images
        )

        let mapper = TVSeriesDetailsMapper()
        let tvSeriesDetails = mapper.map(
            tvSeries,
            imageCollection: imageCollection,
            imagesConfiguration: appConfiguration.images,
            themeColor: themeColor
        )

        span?.finish()
        return tvSeriesDetails
    }

}

extension DefaultFetchTVSeriesDetailsUseCase {

    private func extractThemeColor(
        posterPath: URL?,
        imagesConfiguration: ImagesConfiguration
    ) async -> ThemeColor? {
        guard
            let themeColorProvider,
            let thumbnailURL = imagesConfiguration.posterURLSet(for: posterPath)?.thumbnail
        else {
            return nil
        }

        return await themeColorProvider.themeColor(for: thumbnailURL)
    }

}
